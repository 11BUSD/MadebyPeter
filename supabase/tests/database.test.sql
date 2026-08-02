begin;
create extension if not exists pgtap with schema extensions;
select plan(9);

select ok((select relrowsecurity from pg_class where oid='public.nodes'::regclass),'nodes RLS is enabled');
select ok((select relrowsecurity from pg_class where oid='public.lineage_links'::regclass),'lineage RLS is enabled');
select ok((select count(*) from pg_policies where schemaname='public') >= 20,'least-privilege policies are installed');
select throws_ok($$update public.node_versions set title='forged' where true$$,'immutable record','node versions are immutable');
select throws_ok($$update public.lineage_links set attribution_required=false where true$$,'immutable record','lineage is immutable');
select throws_ok($$insert into public.edges(graph_id,source_node_id,target_node_id,relation_type,created_by) values('20000000-0000-0000-0000-000000000001','30000000-0000-0000-0000-000000000001','30000000-0000-0000-0000-000000000002','part_of','10000000-0000-0000-0000-000000000001')$$,'part_of cycle','part_of cycles are blocked');

set local role anon;
select ok((select count(*) from public.nodes)>0,'anonymous visitor reads public nodes');
select is((select count(*) from public.nodes where visibility='private'),0::bigint,'anonymous visitor cannot read private nodes');
select throws_ok($$delete from public.lineage_links where true$$,'permission denied for table lineage_links','anonymous visitor cannot delete lineage');
reset role;

select * from finish();
rollback;
