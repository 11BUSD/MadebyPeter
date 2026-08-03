begin;
create extension if not exists pgtap with schema extensions;
select plan(17);

select ok((select relrowsecurity from pg_class where oid='public.nodes'::regclass),'nodes RLS is enabled');
select ok((select relrowsecurity from pg_class where oid='public.lineage_links'::regclass),'lineage RLS is enabled');
select ok((select count(*) from pg_policies where schemaname='public') >= 20,'least-privilege policies are installed');
select throws_ok($$update public.node_versions set title='forged' where true$$,'immutable record','node versions are immutable');
insert into public.lineage_links(source_node_id,derived_node_id,source_version_id,source_creator_id,mode,license_snapshot_json,attribution_required,created_by,idempotency_key)
select '30000000-0000-0000-0000-000000000001','30000000-0000-0000-0000-000000000002',current_version_id,'10000000-0000-0000-0000-000000000001','reference','{"policy":"attribution_requested"}',true,'10000000-0000-0000-0000-000000000001','test-lineage-immutable' from public.nodes where id='30000000-0000-0000-0000-000000000001';
select throws_ok($$update public.lineage_links set attribution_required=false where true$$,'immutable record','lineage is immutable');
select throws_ok($$insert into public.edges(graph_id,source_node_id,target_node_id,relation_type,created_by) values('20000000-0000-0000-0000-000000000001','30000000-0000-0000-0000-000000000001','30000000-0000-0000-0000-000000000002','part_of','10000000-0000-0000-0000-000000000001')$$,'part_of cycle','part_of cycles are blocked');

insert into auth.users(id,instance_id,aud,role,email,encrypted_password,email_confirmed_at,created_at,updated_at) values
 ('51000000-0000-4000-8000-000000000001','00000000-0000-0000-0000-000000000000','authenticated','authenticated','owner@example.invalid','',now(),now(),now()),
 ('51000000-0000-4000-8000-000000000002','00000000-0000-0000-0000-000000000000','authenticated','authenticated','editor@example.invalid','',now(),now(),now()),
 ('51000000-0000-4000-8000-000000000003','00000000-0000-0000-0000-000000000000','authenticated','authenticated','viewer@example.invalid','',now(),now(),now());
insert into public.graphs(id,owner_id,title,slug,description,visibility,default_license_policy) values ('52000000-0000-4000-8000-000000000001','51000000-0000-4000-8000-000000000001','Private Test','private-test','RLS fixture','private','private');
insert into public.graph_members(graph_id,user_id,role) values
 ('52000000-0000-4000-8000-000000000001','51000000-0000-4000-8000-000000000002','editor'),
 ('52000000-0000-4000-8000-000000000001','51000000-0000-4000-8000-000000000003','viewer');
insert into public.nodes(id,graph_id,author_id,slug,title,summary,node_type,status,maturity,visibility,license_policy) values ('53000000-0000-4000-8000-000000000001','52000000-0000-4000-8000-000000000001','51000000-0000-4000-8000-000000000001','private-node','Private Node','Private summary','idea','draft','spark','private','private');

set local role authenticated;
set local request.jwt.claims='{"sub":"51000000-0000-4000-8000-000000000001","role":"authenticated"}';
select is((select count(*) from public.nodes where id='53000000-0000-4000-8000-000000000001'),1::bigint,'owner reads private node');
select lives_ok($$select public.branch_idea('30000000-0000-0000-0000-000000000001','52000000-0000-4000-8000-000000000001','fork','branch-test-key','Forked lifecycle')$$,'owner branches public source');
select lives_ok($$select public.branch_idea('30000000-0000-0000-0000-000000000001','52000000-0000-4000-8000-000000000001','fork','branch-test-key','Forked lifecycle')$$,'branch retry is idempotent');
select is((select count(*) from public.lineage_links where created_by='51000000-0000-4000-8000-000000000001' and idempotency_key='branch-test-key'),1::bigint,'idempotent branch creates one lineage row');
reset role;

set local role authenticated;
set local request.jwt.claims='{"sub":"51000000-0000-4000-8000-000000000002","role":"authenticated"}';
update public.nodes set summary='Editor changed' where id='53000000-0000-4000-8000-000000000001';
select is((select summary from public.nodes where id='53000000-0000-4000-8000-000000000001'),'Editor changed','editor can update private graph');
reset role;

set local role authenticated;
set local request.jwt.claims='{"sub":"51000000-0000-4000-8000-000000000003","role":"authenticated"}';
update public.nodes set summary='Viewer changed' where id='53000000-0000-4000-8000-000000000001';
select is((select summary from public.nodes where id='53000000-0000-4000-8000-000000000001'),'Editor changed','viewer cannot update private graph');
reset role;

set local role anon;
set local request.jwt.claims='{}';
select ok((select count(*) from public.nodes)>0,'anonymous visitor reads public nodes');
select is((select count(*) from public.nodes where visibility='private'),0::bigint,'anonymous visitor cannot read private nodes');
select is((select count(*) from public.graph_members),0::bigint,'anonymous visitor cannot enumerate graph members');
select is((select count(*) from public.artifacts where external_url is not null),3::bigint,'anonymous visitor reads only public external embeds');
select throws_ok($$delete from public.lineage_links where true$$,'permission denied for table lineage_links','anonymous visitor cannot delete lineage');
reset role;

select * from finish();
rollback;
