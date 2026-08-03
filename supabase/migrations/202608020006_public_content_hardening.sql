drop policy members_read on public.graph_members;
create policy members_read on public.graph_members for select using (public.is_graph_member(graph_id));

create function public.can_read_public_artifact(target_artifact uuid)
returns boolean language sql stable security definer set search_path='' as $$
  select exists(
    select 1 from public.artifacts a
    join public.node_artifacts na on na.artifact_id=a.id
    join public.nodes n on n.id=na.node_id
    join public.graphs g on g.id=n.graph_id
    where a.id=target_artifact and a.storage_path is null and a.external_url is not null
      and n.deleted_at is null and g.deleted_at is null
      and n.status='published' and n.visibility='public' and g.visibility='public'
  );
$$;
create policy artifacts_public_embed on public.artifacts for select using (public.can_read_public_artifact(id));
