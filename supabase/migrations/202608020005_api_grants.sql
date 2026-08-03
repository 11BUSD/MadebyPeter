grant usage on schema public to anon, authenticated;

grant select on public.profiles, public.social_links, public.graphs, public.graph_members,
  public.nodes, public.node_versions, public.edges, public.lineage_links,
  public.graph_node_positions, public.artifacts, public.node_artifacts,
  public.sources, public.node_sources to anon, authenticated;

grant select, insert, update, delete on public.profiles, public.social_links, public.graphs,
  public.graph_members, public.nodes, public.edges, public.graph_node_positions,
  public.artifacts, public.node_artifacts, public.sources, public.node_sources,
  public.bookmarks, public.follows, public.email_consents,
  public.agent_definitions, public.agent_versions, public.agent_runs to authenticated;

grant select, insert on public.node_versions to authenticated;
grant select on public.audit_events to authenticated;

revoke insert, update, delete on public.lineage_links from anon, authenticated;
revoke update, delete on public.node_versions, public.audit_events from anon, authenticated;
