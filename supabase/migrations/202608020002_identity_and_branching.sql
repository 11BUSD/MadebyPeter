create function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = '' as $$
declare
  candidate text;
begin
  candidate := lower(regexp_replace(coalesce(new.raw_user_meta_data->>'username', split_part(coalesce(new.email, ''),'@',1), 'creator'), '[^a-z0-9_-]', '', 'g'));
  if char_length(candidate) < 3 then candidate := 'creator'; end if;
  candidate := left(candidate, 20) || '_' || left(replace(new.id::text,'-',''),8);
  insert into public.profiles(id,username,display_name)
  values(new.id,candidate,coalesce(nullif(new.raw_user_meta_data->>'full_name',''), 'New creator'))
  on conflict(id) do nothing;
  return new;
end $$;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();

create function public.branch_idea(
  p_source_node uuid,
  p_target_graph uuid,
  p_mode public.lineage_mode,
  p_idempotency_key text,
  p_title text default null
) returns uuid
language plpgsql security definer set search_path = '' as $$
declare
  actor uuid := auth.uid();
  source_row public.nodes%rowtype;
  new_node uuid;
  new_version uuid;
  existing_node uuid;
  next_slug text;
begin
  if actor is null then raise exception 'authentication required'; end if;
  if char_length(p_idempotency_key) < 8 or char_length(p_idempotency_key) > 120 then raise exception 'invalid idempotency key'; end if;

  select derived_node_id into existing_node from public.lineage_links
  where created_by=actor and idempotency_key=p_idempotency_key;
  if existing_node is not null then return existing_node; end if;

  select n.* into source_row from public.nodes n
  where n.id=p_source_node and n.deleted_at is null and n.status='published'
    and public.can_read_graph(n.graph_id) and (n.visibility in ('public','unlisted') or public.is_graph_member(n.graph_id));
  if not found then raise exception 'source not available'; end if;
  if source_row.current_version_id is null then raise exception 'source has no published version'; end if;
  if not public.can_edit_graph(p_target_graph) then raise exception 'target graph not editable'; end if;

  next_slug := left(regexp_replace(lower(coalesce(nullif(p_title,''),source_row.title)), '[^a-z0-9]+','-','g'),80);
  next_slug := trim(both '-' from next_slug) || '-' || left(replace(gen_random_uuid()::text,'-',''),8);

  insert into public.nodes(graph_id,author_id,slug,title,summary,node_type,status,maturity,visibility,license_policy,origin_node_id,published_at)
  values(p_target_graph,actor,next_slug,coalesce(nullif(p_title,''),source_row.title),source_row.summary,source_row.node_type,'draft',source_row.maturity,'private',source_row.license_policy,source_row.id,null)
  returning id into new_node;

  insert into public.node_versions(node_id,version_number,title,summary,content_json,content_hash,created_by)
  select new_node,1,coalesce(nullif(p_title,''),v.title),v.summary,v.content_json,
    encode(digest(coalesce(nullif(p_title,''),v.title)||v.summary||v.content_json::text,'sha256'),'hex'),actor
  from public.node_versions v where v.id=source_row.current_version_id returning id into new_version;
  update public.nodes set current_version_id=new_version where id=new_node;

  insert into public.lineage_links(source_node_id,derived_node_id,source_version_id,source_creator_id,mode,license_snapshot_json,attribution_required,created_by,idempotency_key)
  values(source_row.id,new_node,source_row.current_version_id,source_row.author_id,p_mode,
    jsonb_build_object('policy',source_row.license_policy,'captured_at',now()),true,actor,p_idempotency_key);
  insert into public.audit_events(actor_user_id,event_type,resource_type,resource_id,metadata_json)
  values(actor,'lineage.created','node',new_node,jsonb_build_object('source_node_id',source_row.id,'mode',p_mode));
  return new_node;
exception when unique_violation then
  select derived_node_id into existing_node from public.lineage_links where created_by=actor and idempotency_key=p_idempotency_key;
  if existing_node is not null then return existing_node; end if;
  raise;
end $$;
revoke all on function public.branch_idea(uuid,uuid,public.lineage_mode,text,text) from public, anon;
grant execute on function public.branch_idea(uuid,uuid,public.lineage_mode,text,text) to authenticated;

create function public.search_public_ideas(p_query text, p_limit integer default 20)
returns table(id uuid, slug text, title text, summary text, node_type text, graph_id uuid, rank real)
language sql stable security definer set search_path = '' as $$
  select n.id,n.slug::text,n.title,n.summary,n.node_type,n.graph_id,
    ts_rank(n.search_document,websearch_to_tsquery('english',left(p_query,120))) rank
  from public.nodes n join public.graphs g on g.id=n.graph_id
  where n.deleted_at is null and g.deleted_at is null and n.status='published'
    and n.visibility='public' and g.visibility='public'
    and n.search_document @@ websearch_to_tsquery('english',left(p_query,120))
  order by rank desc,n.published_at desc limit least(greatest(p_limit,1),50);
$$;
grant execute on function public.search_public_ideas(text,integer) to anon,authenticated;
