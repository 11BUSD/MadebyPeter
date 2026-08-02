create function public.create_idea(
  p_graph_id uuid, p_title text, p_summary text, p_description text,
  p_node_type text, p_visibility public.content_visibility, p_publish boolean
) returns uuid language plpgsql security definer set search_path='' as $$
declare actor uuid:=auth.uid(); new_node uuid; new_version uuid; next_slug text;
begin
  if actor is null or not public.can_edit_graph(p_graph_id) then raise exception 'not authorized'; end if;
  if char_length(trim(p_title)) not between 1 and 160 or char_length(trim(p_summary)) not between 1 and 400 then raise exception 'invalid idea'; end if;
  if p_node_type not in ('idea','song','research','question','goal','product','system','person','place','event','artifact','build','collection') then raise exception 'invalid node type'; end if;
  next_slug:=trim(both '-' from left(regexp_replace(lower(p_title),'[^a-z0-9]+','-','g'),80))||'-'||left(replace(gen_random_uuid()::text,'-',''),8);
  insert into public.nodes(graph_id,author_id,slug,title,summary,node_type,status,maturity,visibility,license_policy,published_at)
  values(p_graph_id,actor,next_slug,trim(p_title),trim(p_summary),p_node_type,case when p_publish then 'published'::public.node_status else 'draft'::public.node_status end,'spark',p_visibility,case when p_visibility='private' then 'private' else 'attribution_requested' end,case when p_publish then now() end)
  returning id into new_node;
  insert into public.node_versions(node_id,version_number,title,summary,content_json,content_hash,created_by)
  values(new_node,1,trim(p_title),trim(p_summary),jsonb_build_object('body',left(p_description,10000)),encode(digest(trim(p_title)||trim(p_summary)||left(p_description,10000),'sha256'),'hex'),actor)
  returning id into new_version;
  update public.nodes set current_version_id=new_version where id=new_node;
  insert into public.audit_events(actor_user_id,event_type,resource_type,resource_id,metadata_json) values(actor,case when p_publish then 'node.published' else 'node.created' end,'node',new_node,'{}');
  return new_node;
end $$;
revoke all on function public.create_idea(uuid,text,text,text,text,public.content_visibility,boolean) from public,anon;
grant execute on function public.create_idea(uuid,text,text,text,text,public.content_visibility,boolean) to authenticated;

create function public.connect_ideas(p_graph_id uuid,p_source uuid,p_target uuid,p_relation text)
returns uuid language plpgsql security definer set search_path='' as $$
declare actor uuid:=auth.uid(); edge_id uuid;
begin
  if actor is null or not public.can_edit_graph(p_graph_id) then raise exception 'not authorized'; end if;
  insert into public.edges(graph_id,source_node_id,target_node_id,relation_type,created_by) values(p_graph_id,p_source,p_target,p_relation,actor) returning id into edge_id;
  insert into public.audit_events(actor_user_id,event_type,resource_type,resource_id,metadata_json) values(actor,'edge.created','edge',edge_id,jsonb_build_object('relation',p_relation));
  return edge_id;
end $$;
revoke all on function public.connect_ideas(uuid,uuid,uuid,text) from public,anon;
grant execute on function public.connect_ideas(uuid,uuid,uuid,text) to authenticated;
