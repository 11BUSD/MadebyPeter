create table public.capture_idempotency (
  user_id uuid not null references public.profiles(id) on delete cascade,
  idempotency_key text not null check (char_length(idempotency_key) between 8 and 120),
  node_id uuid not null references public.nodes(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, idempotency_key)
);

alter table public.capture_idempotency enable row level security;
revoke all on public.capture_idempotency from public, anon, authenticated;

create function public.capture_idea(
  p_graph_id uuid,
  p_title text,
  p_summary text,
  p_description text,
  p_node_type text,
  p_visibility public.content_visibility,
  p_publish boolean,
  p_idempotency_key text
) returns jsonb
language plpgsql
security definer
set search_path = '' as $$
declare
  actor uuid := auth.uid();
  target_graph uuid := p_graph_id;
  existing_node uuid;
  new_node uuid;
  graph_slug text;
begin
  if actor is null then raise exception 'authentication required'; end if;
  if char_length(p_idempotency_key) not between 8 and 120 then raise exception 'invalid idempotency key'; end if;

  perform pg_advisory_xact_lock(hashtextextended(actor::text || ':' || p_idempotency_key, 0));
  select node_id into existing_node
  from public.capture_idempotency
  where user_id = actor and idempotency_key = p_idempotency_key;

  if existing_node is not null then
    select n.graph_id into target_graph from public.nodes n where n.id = existing_node;
    return jsonb_build_object('nodeId', existing_node, 'graphId', target_graph, 'replayed', true);
  end if;

  if target_graph is null then
    graph_slug := 'my-ideas-' || left(replace(gen_random_uuid()::text, '-', ''), 8);
    insert into public.graphs(owner_id, title, slug, description, visibility, default_license_policy)
    values(actor, 'My Ideas', graph_slug, 'A private place for ideas in progress.', 'private', 'private')
    returning id into target_graph;

    insert into public.graph_members(graph_id, user_id, role)
    values(target_graph, actor, 'owner');
  elsif not public.can_edit_graph(target_graph) then
    raise exception 'not authorized';
  end if;

  new_node := public.create_idea(
    target_graph,
    p_title,
    p_summary,
    coalesce(p_description, ''),
    p_node_type,
    p_visibility,
    p_publish
  );

  insert into public.capture_idempotency(user_id, idempotency_key, node_id)
  values(actor, p_idempotency_key, new_node);

  return jsonb_build_object('nodeId', new_node, 'graphId', target_graph, 'replayed', false);
end $$;

revoke all on function public.capture_idea(uuid,text,text,text,text,public.content_visibility,boolean,text) from public, anon;
grant execute on function public.capture_idea(uuid,text,text,text,text,public.content_visibility,boolean,text) to authenticated;
