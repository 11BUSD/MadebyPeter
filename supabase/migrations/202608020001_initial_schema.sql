create extension if not exists citext;
create extension if not exists pgcrypto;

create type public.content_visibility as enum ('public', 'unlisted', 'private');
create type public.graph_role as enum ('owner', 'editor', 'commenter', 'viewer');
create type public.node_status as enum ('draft', 'published', 'archived', 'under_review');
create type public.node_maturity as enum ('spark', 'concept', 'opportunity', 'blueprint', 'institutional');
create type public.lineage_mode as enum ('reference', 'fork', 'remix');
create type public.consent_status as enum ('granted', 'withdrawn');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username citext not null unique check (username ~ '^[a-z0-9][a-z0-9_-]{2,29}$'),
  display_name text not null check (char_length(display_name) between 1 and 80),
  bio text not null default '' check (char_length(bio) <= 500),
  avatar_url text,
  public_email text,
  location_text text,
  website_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.social_links (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  platform text not null,
  url text not null check (url ~ '^https://'),
  label text not null default '',
  is_verified boolean not null default false,
  sort_order integer not null default 0
);

create table public.graphs (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id),
  title text not null check (char_length(title) between 1 and 120),
  slug citext not null check (slug ~ '^[a-z0-9][a-z0-9-]{1,79}$'),
  description text not null default '' check (char_length(description) <= 2000),
  visibility public.content_visibility not null default 'private',
  default_license_policy text not null default 'private',
  root_node_id uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique(owner_id, slug)
);

create table public.graph_members (
  graph_id uuid not null references public.graphs(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role public.graph_role not null,
  created_at timestamptz not null default now(),
  primary key (graph_id, user_id)
);

create table public.nodes (
  id uuid primary key default gen_random_uuid(),
  graph_id uuid not null references public.graphs(id) on delete cascade,
  author_id uuid not null references public.profiles(id),
  slug citext not null check (slug ~ '^[a-z0-9][a-z0-9-]{1,99}$'),
  title text not null check (char_length(title) between 1 and 160),
  summary text not null check (char_length(summary) between 1 and 400),
  node_type text not null check (node_type in ('idea','song','research','question','goal','product','system','person','place','event','artifact','build','collection')),
  status public.node_status not null default 'draft',
  maturity public.node_maturity not null default 'spark',
  visibility public.content_visibility not null default 'private',
  license_policy text not null default 'private' check (license_policy in ('open_inspiration','attribution_requested','commercial_discussion','private')),
  current_version_id uuid,
  origin_node_id uuid references public.nodes(id),
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  search_document tsvector generated always as (to_tsvector('english', coalesce(title,'') || ' ' || coalesce(summary,''))) stored,
  unique(graph_id, slug)
);

alter table public.graphs add constraint graphs_root_node_fk foreign key (root_node_id) references public.nodes(id) deferrable initially deferred;

create table public.node_versions (
  id uuid primary key default gen_random_uuid(),
  node_id uuid not null references public.nodes(id) on delete restrict,
  version_number integer not null check (version_number > 0),
  title text not null,
  summary text not null,
  content_json jsonb not null default '{}',
  content_hash text not null check (content_hash ~ '^[a-f0-9]{64}$'),
  created_by uuid not null references public.profiles(id),
  created_at timestamptz not null default now(),
  unique(node_id, version_number),
  unique(node_id, id)
);

alter table public.nodes add constraint nodes_current_version_fk foreign key (id, current_version_id) references public.node_versions(node_id, id) deferrable initially deferred;

create table public.edges (
  id uuid primary key default gen_random_uuid(),
  graph_id uuid not null references public.graphs(id) on delete cascade,
  source_node_id uuid not null references public.nodes(id),
  target_node_id uuid not null references public.nodes(id),
  relation_type text not null check (relation_type in ('part_of','related_to','expands','requires','enables','explains','supports','challenges','contradicts','soundtrack_for','built_by','builds_on','produces','derived_from')),
  label text check (char_length(label) <= 120),
  created_by uuid not null references public.profiles(id),
  created_at timestamptz not null default now(),
  deleted_at timestamptz,
  check (source_node_id <> target_node_id),
  unique(graph_id, source_node_id, target_node_id, relation_type)
);

create table public.lineage_links (
  id uuid primary key default gen_random_uuid(),
  source_node_id uuid not null references public.nodes(id) on delete restrict,
  derived_node_id uuid not null references public.nodes(id) on delete restrict,
  source_version_id uuid not null references public.node_versions(id) on delete restrict,
  source_creator_id uuid not null references public.profiles(id) on delete restrict,
  mode public.lineage_mode not null,
  license_snapshot_json jsonb not null,
  attribution_required boolean not null default true,
  created_by uuid not null references public.profiles(id),
  idempotency_key text not null,
  created_at timestamptz not null default now(),
  check (source_node_id <> derived_node_id),
  unique(created_by, idempotency_key)
);

create table public.graph_node_positions (
  graph_id uuid not null references public.graphs(id) on delete cascade,
  node_id uuid not null references public.nodes(id) on delete cascade,
  x double precision not null,
  y double precision not null,
  parent_cluster_id uuid references public.nodes(id),
  is_collapsed boolean not null default false,
  layout_version integer not null default 1,
  updated_by uuid not null references public.profiles(id),
  updated_at timestamptz not null default now(),
  primary key(graph_id, node_id)
);

create table public.artifacts (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null references public.profiles(id),
  artifact_type text not null, title text not null, storage_path text, external_url text,
  mime_type text, size_bytes bigint check (size_bytes is null or size_bytes >= 0),
  metadata_json jsonb not null default '{}', created_at timestamptz not null default now(),
  check ((storage_path is null) <> (external_url is null))
);
create table public.node_artifacts (
  node_id uuid not null references public.nodes(id) on delete cascade,
  artifact_id uuid not null references public.artifacts(id) on delete cascade,
  role text not null check (role in ('cover','audio','video','attachment','dataset','design','code','external_embed')),
  sort_order integer not null default 0, primary key(node_id, artifact_id)
);
create table public.sources (
  id uuid primary key default gen_random_uuid(), url text not null check (url ~ '^https://'), title text not null,
  publisher text not null default '', published_at timestamptz, accessed_at timestamptz not null default now(), metadata_json jsonb not null default '{}'
);
create table public.node_sources (
  node_id uuid not null references public.nodes(id) on delete cascade, source_id uuid not null references public.sources(id) on delete cascade,
  claim_summary text not null, evidence_type text not null, confidence numeric(3,2) check (confidence between 0 and 1),
  added_by uuid not null references public.profiles(id), created_at timestamptz not null default now(), primary key(node_id, source_id)
);
create table public.bookmarks (
  user_id uuid not null references public.profiles(id) on delete cascade, node_id uuid not null references public.nodes(id) on delete cascade,
  created_at timestamptz not null default now(), primary key(user_id, node_id)
);
create table public.follows (
  follower_id uuid not null references public.profiles(id) on delete cascade,
  followed_profile_id uuid references public.profiles(id) on delete cascade,
  followed_graph_id uuid references public.graphs(id) on delete cascade,
  created_at timestamptz not null default now(),
  check ((followed_profile_id is null) <> (followed_graph_id is null)),
  unique nulls not distinct (follower_id, followed_profile_id, followed_graph_id)
);
create table public.email_consents (
  id uuid primary key default gen_random_uuid(), user_id uuid not null references public.profiles(id) on delete cascade,
  consent_type text not null check (consent_type in ('product_updates','weekly_digest','marketplace','research')),
  status public.consent_status not null, policy_version text not null, source text not null,
  captured_at timestamptz not null default now(), withdrawn_at timestamptz,
  check ((status = 'granted' and withdrawn_at is null) or (status = 'withdrawn' and withdrawn_at is not null))
);
create table public.audit_events (
  id uuid primary key default gen_random_uuid(), actor_user_id uuid references public.profiles(id), event_type text not null,
  resource_type text not null, resource_id uuid, metadata_json jsonb not null default '{}', created_at timestamptz not null default now()
);

create table public.agent_definitions (
  id uuid primary key default gen_random_uuid(), owner_id uuid not null references public.profiles(id), name text not null,
  description text not null default '', agent_type text not null check (agent_type in ('capture','structure')),
  visibility public.content_visibility not null default 'private', input_schema_json jsonb not null, output_schema_json jsonb not null,
  tool_policy_json jsonb not null default '{"allowed":[]}', current_version_id uuid, created_at timestamptz not null default now()
);
create table public.agent_versions (
  id uuid primary key default gen_random_uuid(), agent_id uuid not null references public.agent_definitions(id) on delete cascade,
  version_number integer not null, instruction_template text not null, model_policy_json jsonb not null,
  evaluation_summary_json jsonb not null default '{}', change_log text not null default '', created_at timestamptz not null default now(),
  unique(agent_id, version_number), unique(agent_id, id)
);
alter table public.agent_definitions add constraint agent_current_version_fk foreign key (id,current_version_id) references public.agent_versions(agent_id,id) deferrable initially deferred;
create table public.agent_runs (
  id uuid primary key default gen_random_uuid(), agent_version_id uuid not null references public.agent_versions(id), requested_by uuid not null references public.profiles(id),
  node_id uuid references public.nodes(id), graph_id uuid references public.graphs(id), input_scope_json jsonb not null,
  status text not null check (status in ('queued','running','completed','failed')), output_json jsonb,
  source_manifest_json jsonb not null default '[]', provider text not null, model text not null,
  estimated_cost numeric(12,6) not null default 0, error_json jsonb, created_at timestamptz not null default now(), completed_at timestamptz
);

create index nodes_public_search_idx on public.nodes using gin(search_document) where deleted_at is null and status = 'published' and visibility = 'public';
create index edges_source_idx on public.edges(source_node_id) where deleted_at is null;
create index edges_target_idx on public.edges(target_node_id) where deleted_at is null;
create index lineage_source_idx on public.lineage_links(source_node_id);
create index lineage_derived_idx on public.lineage_links(derived_node_id);

create function public.is_graph_member(target_graph uuid, allowed_roles public.graph_role[] default array['owner','editor','commenter','viewer']::public.graph_role[])
returns boolean language sql stable security definer set search_path = '' as $$
  select exists(select 1 from public.graphs g where g.id=target_graph and g.owner_id=auth.uid())
    or exists(select 1 from public.graph_members gm where gm.graph_id=target_graph and gm.user_id=auth.uid() and gm.role=any(allowed_roles));
$$;
create function public.can_read_graph(target_graph uuid)
returns boolean language sql stable security definer set search_path = '' as $$
  select exists(select 1 from public.graphs g where g.id=target_graph and g.deleted_at is null and (g.visibility in ('public','unlisted') or public.is_graph_member(g.id)));
$$;
create function public.can_edit_graph(target_graph uuid)
returns boolean language sql stable security definer set search_path = '' as $$
  select public.is_graph_member(target_graph, array['owner','editor']::public.graph_role[]);
$$;

create function public.reject_immutable_change() returns trigger language plpgsql as $$ begin raise exception 'immutable record'; end $$;
create trigger node_versions_immutable before update or delete on public.node_versions for each row execute function public.reject_immutable_change();
create trigger lineage_immutable before update or delete on public.lineage_links for each row execute function public.reject_immutable_change();
create trigger audit_immutable before update or delete on public.audit_events for each row execute function public.reject_immutable_change();

create function public.check_part_of_cycle() returns trigger language plpgsql as $$
begin
  if new.relation_type = 'part_of' and exists (
    with recursive ancestors(id) as (
      select new.target_node_id union
      select e.target_node_id from public.edges e join ancestors a on e.source_node_id=a.id
      where e.graph_id=new.graph_id and e.relation_type='part_of' and e.deleted_at is null
    ) select 1 from ancestors where id=new.source_node_id
  ) then raise exception 'part_of cycle'; end if;
  if not exists(select 1 from public.nodes s join public.nodes t on t.id=new.target_node_id where s.id=new.source_node_id and s.graph_id=new.graph_id and t.graph_id=new.graph_id) then
    raise exception 'edge nodes must belong to graph';
  end if;
  return new;
end $$;
create trigger edges_cycle_guard before insert or update on public.edges for each row execute function public.check_part_of_cycle();

alter table public.profiles enable row level security;
alter table public.social_links enable row level security;
alter table public.graphs enable row level security;
alter table public.graph_members enable row level security;
alter table public.nodes enable row level security;
alter table public.node_versions enable row level security;
alter table public.edges enable row level security;
alter table public.lineage_links enable row level security;
alter table public.graph_node_positions enable row level security;
alter table public.artifacts enable row level security;
alter table public.node_artifacts enable row level security;
alter table public.sources enable row level security;
alter table public.node_sources enable row level security;
alter table public.bookmarks enable row level security;
alter table public.follows enable row level security;
alter table public.email_consents enable row level security;
alter table public.audit_events enable row level security;
alter table public.agent_definitions enable row level security;
alter table public.agent_versions enable row level security;
alter table public.agent_runs enable row level security;

create policy profiles_public_read on public.profiles for select using (true);
create policy profiles_self_update on public.profiles for update using (id=auth.uid()) with check (id=auth.uid());
create policy social_public_read on public.social_links for select using (true);
create policy social_self_manage on public.social_links for all using (profile_id=auth.uid()) with check (profile_id=auth.uid());
create policy graphs_read on public.graphs for select using (deleted_at is null and (visibility in ('public','unlisted') or public.is_graph_member(id)));
create policy graphs_insert on public.graphs for insert with check (owner_id=auth.uid());
create policy graphs_update on public.graphs for update using (public.can_edit_graph(id)) with check (public.can_edit_graph(id));
create policy members_read on public.graph_members for select using (public.can_read_graph(graph_id));
create policy members_owner_manage on public.graph_members for all using (exists(select 1 from public.graphs g where g.id=graph_id and g.owner_id=auth.uid())) with check (exists(select 1 from public.graphs g where g.id=graph_id and g.owner_id=auth.uid()));
create policy nodes_read on public.nodes for select using (deleted_at is null and public.can_read_graph(graph_id) and (visibility in ('public','unlisted') or public.is_graph_member(graph_id)));
create policy nodes_insert on public.nodes for insert with check (author_id=auth.uid() and public.can_edit_graph(graph_id));
create policy nodes_update on public.nodes for update using (public.can_edit_graph(graph_id)) with check (public.can_edit_graph(graph_id));
create policy versions_read on public.node_versions for select using (exists(select 1 from public.nodes n where n.id=node_id));
create policy versions_insert on public.node_versions for insert with check (created_by=auth.uid() and exists(select 1 from public.nodes n where n.id=node_id and public.can_edit_graph(n.graph_id)));
create policy edges_read on public.edges for select using (deleted_at is null and public.can_read_graph(graph_id));
create policy edges_manage on public.edges for all using (public.can_edit_graph(graph_id)) with check (created_by=auth.uid() and public.can_edit_graph(graph_id));
create policy lineage_read on public.lineage_links for select using (exists(select 1 from public.nodes n where n.id=derived_node_id));
create policy positions_read on public.graph_node_positions for select using (public.can_read_graph(graph_id));
create policy positions_manage on public.graph_node_positions for all using (public.can_edit_graph(graph_id)) with check (updated_by=auth.uid() and public.can_edit_graph(graph_id));
create policy artifacts_owner on public.artifacts for all using (owner_id=auth.uid()) with check (owner_id=auth.uid());
create policy node_artifacts_read on public.node_artifacts for select using (exists(select 1 from public.nodes n where n.id=node_id));
create policy node_artifacts_manage on public.node_artifacts for all using (exists(select 1 from public.nodes n where n.id=node_id and public.can_edit_graph(n.graph_id))) with check (exists(select 1 from public.nodes n where n.id=node_id and public.can_edit_graph(n.graph_id)));
create policy sources_read on public.sources for select using (exists(select 1 from public.node_sources ns join public.nodes n on n.id=ns.node_id where ns.source_id=id));
create policy node_sources_read on public.node_sources for select using (exists(select 1 from public.nodes n where n.id=node_id));
create policy node_sources_manage on public.node_sources for all using (exists(select 1 from public.nodes n where n.id=node_id and public.can_edit_graph(n.graph_id))) with check (added_by=auth.uid() and exists(select 1 from public.nodes n where n.id=node_id and public.can_edit_graph(n.graph_id)));
create policy bookmarks_self on public.bookmarks for all using (user_id=auth.uid()) with check (user_id=auth.uid());
create policy follows_self on public.follows for all using (follower_id=auth.uid()) with check (follower_id=auth.uid());
create policy consents_self on public.email_consents for select using (user_id=auth.uid());
create policy consents_insert on public.email_consents for insert with check (user_id=auth.uid());
create policy audits_actor_read on public.audit_events for select using (actor_user_id=auth.uid());
create policy agent_defs_owner on public.agent_definitions for all using (owner_id=auth.uid()) with check (owner_id=auth.uid());
create policy agent_versions_owner on public.agent_versions for select using (exists(select 1 from public.agent_definitions a where a.id=agent_id and a.owner_id=auth.uid()));
create policy agent_runs_authorized on public.agent_runs for select using (requested_by=auth.uid() or (graph_id is not null and public.is_graph_member(graph_id)));
create policy agent_runs_insert on public.agent_runs for insert with check (requested_by=auth.uid() and (graph_id is null or public.can_read_graph(graph_id)));

revoke all on public.lineage_links from anon, authenticated;
grant select on public.lineage_links to anon, authenticated;
revoke update, delete on public.node_versions, public.audit_events from anon, authenticated;
