-- Synthetic, public-safe fixture. Fixed UUIDs make reset and browser tests deterministic.
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000000','authenticated','authenticated','peter@example.invalid','',now(),now(),now())
on conflict (id) do nothing;

insert into public.profiles(id,username,display_name,bio)
values ('10000000-0000-0000-0000-000000000001','peter','Peter','Exploring how complex systems become understandable ideas.')
on conflict (id) do nothing;

insert into public.graphs(id,owner_id,title,slug,description,visibility,default_license_policy)
values ('20000000-0000-0000-0000-000000000001','10000000-0000-0000-0000-000000000001','Energy Systems','energy-systems','A synthetic tour through the LNG lifecycle.','public','attribution_requested')
on conflict (id) do nothing;

insert into public.graph_members(graph_id,user_id,role) values ('20000000-0000-0000-0000-000000000001','10000000-0000-0000-0000-000000000001','owner') on conflict do nothing;

insert into public.nodes(id,graph_id,author_id,slug,title,summary,node_type,status,maturity,visibility,license_policy,published_at)
select id::uuid,'20000000-0000-0000-0000-000000000001','10000000-0000-0000-0000-000000000001',slug,title,summary,node_type,'published','concept','public','attribution_requested',now()
from (values
 ('30000000-0000-0000-0000-000000000001','lng-lifecycle','LNG Lifecycle','From conditioned gas to grid injection: the connected stages of liquefied natural gas.','system'),
 ('30000000-0000-0000-0000-000000000002','gas-conditioning','Gas conditioning','Preparing feed gas by removing components that interfere with liquefaction.','idea'),
 ('30000000-0000-0000-0000-000000000003','liquefaction','Liquefaction','Cooling natural gas until it becomes a compact transportable liquid.','idea'),
 ('30000000-0000-0000-0000-000000000004','storage','Storage','Holding LNG in insulated tanks while managing heat ingress and pressure.','idea'),
 ('30000000-0000-0000-0000-000000000005','ship-loading','Ship loading','Moving LNG safely from terminal storage into a carrier.','idea'),
 ('30000000-0000-0000-0000-000000000006','custody-transfer','Custody transfer','Measuring transferred energy and quantity at a commercial handoff.','research'),
 ('30000000-0000-0000-0000-000000000007','marine-transport','Marine transport','Carrying LNG between terminals while managing cargo condition.','idea'),
 ('30000000-0000-0000-0000-000000000008','boil-off-gas','Boil-off gas','Vapour created as heat enters a cryogenic cargo system.','idea'),
 ('30000000-0000-0000-0000-000000000009','heel-management','Heel management','Retaining and managing cargo needed to keep tanks cold.','idea'),
 ('30000000-0000-0000-0000-000000000010','reliquefaction','Reliquefaction','Returning boil-off vapour to liquid form aboard a vessel.','idea'),
 ('30000000-0000-0000-0000-000000000011','ship-to-ship-transfer','Ship-to-ship transfer','Transferring LNG between vessels with controlled interfaces.','idea'),
 ('30000000-0000-0000-0000-000000000012','floating-storage','Floating storage','Using a vessel or floating unit as flexible LNG storage.','idea'),
 ('30000000-0000-0000-0000-000000000013','fsru','FSRU','A floating unit that stores LNG and converts it back to gas.','system'),
 ('30000000-0000-0000-0000-000000000014','regasification','Regasification','Warming LNG so it returns to gaseous form for delivery.','idea'),
 ('30000000-0000-0000-0000-000000000015','grid-injection','Grid injection','Delivering conditioned gas into the receiving network.','idea'),
 ('30000000-0000-0000-0000-000000000016','minus-162','−162°C','A synthetic music concept translating cryogenic transformation into sound.','song'),
 ('30000000-0000-0000-0000-000000000017','ship-to-shore','Ship to Shore','A synthetic music concept about the choreography of transfer.','song'),
 ('30000000-0000-0000-0000-000000000018','regas','Regas','A synthetic music concept about returning stored potential to motion.','song')
) as n(id,slug,title,summary,node_type) on conflict (id) do nothing;

insert into public.node_versions(id,node_id,version_number,title,summary,content_json,content_hash,created_by)
select gen_random_uuid(),id,1,title,summary,jsonb_build_object('body',summary),encode(digest(title||summary,'sha256'),'hex'),author_id from public.nodes
where graph_id='20000000-0000-0000-0000-000000000001' and current_version_id is null;
update public.nodes n set current_version_id=v.id from public.node_versions v where v.node_id=n.id and n.current_version_id is null;
update public.graphs set root_node_id='30000000-0000-0000-0000-000000000001' where id='20000000-0000-0000-0000-000000000001';

insert into public.edges(graph_id,source_node_id,target_node_id,relation_type,created_by)
select '20000000-0000-0000-0000-000000000001',source_id::uuid,target_id::uuid,relation,'10000000-0000-0000-0000-000000000001'
from (values
 ('30000000-0000-0000-0000-000000000002','30000000-0000-0000-0000-000000000001','part_of'),
 ('30000000-0000-0000-0000-000000000003','30000000-0000-0000-0000-000000000001','part_of'),
 ('30000000-0000-0000-0000-000000000004','30000000-0000-0000-0000-000000000001','part_of'),
 ('30000000-0000-0000-0000-000000000005','30000000-0000-0000-0000-000000000001','part_of'),
 ('30000000-0000-0000-0000-000000000007','30000000-0000-0000-0000-000000000001','part_of'),
 ('30000000-0000-0000-0000-000000000012','30000000-0000-0000-0000-000000000001','part_of'),
 ('30000000-0000-0000-0000-000000000013','30000000-0000-0000-0000-000000000001','part_of'),
 ('30000000-0000-0000-0000-000000000014','30000000-0000-0000-0000-000000000001','part_of'),
 ('30000000-0000-0000-0000-000000000015','30000000-0000-0000-0000-000000000001','part_of'),
 ('30000000-0000-0000-0000-000000000006','30000000-0000-0000-0000-000000000005','requires'),
 ('30000000-0000-0000-0000-000000000008','30000000-0000-0000-0000-000000000007','part_of'),
 ('30000000-0000-0000-0000-000000000009','30000000-0000-0000-0000-000000000007','part_of'),
 ('30000000-0000-0000-0000-000000000010','30000000-0000-0000-0000-000000000007','part_of'),
 ('30000000-0000-0000-0000-000000000011','30000000-0000-0000-0000-000000000007','part_of'),
 ('30000000-0000-0000-0000-000000000013','30000000-0000-0000-0000-000000000014','enables'),
 ('30000000-0000-0000-0000-000000000016','30000000-0000-0000-0000-000000000003','soundtrack_for'),
 ('30000000-0000-0000-0000-000000000017','30000000-0000-0000-0000-000000000005','soundtrack_for'),
 ('30000000-0000-0000-0000-000000000018','30000000-0000-0000-0000-000000000014','soundtrack_for')
) e(source_id,target_id,relation) on conflict do nothing;

insert into public.artifacts(id,owner_id,artifact_type,title,external_url,metadata_json)
values
 ('40000000-0000-0000-0000-000000000001','10000000-0000-0000-0000-000000000001','external_embed','−162°C — illustrative fallback','https://soundcloud.com/soundcloud','{"provider":"soundcloud","synthetic":true}'),
 ('40000000-0000-0000-0000-000000000002','10000000-0000-0000-0000-000000000001','external_embed','Ship to Shore — illustrative fallback','https://soundcloud.com/soundcloud','{"provider":"soundcloud","synthetic":true}'),
 ('40000000-0000-0000-0000-000000000003','10000000-0000-0000-0000-000000000001','external_embed','Regas — illustrative fallback','https://soundcloud.com/soundcloud','{"provider":"soundcloud","synthetic":true}')
on conflict(id) do nothing;
insert into public.node_artifacts(node_id,artifact_id,role,sort_order) values
 ('30000000-0000-0000-0000-000000000016','40000000-0000-0000-0000-000000000001','external_embed',0),
 ('30000000-0000-0000-0000-000000000017','40000000-0000-0000-0000-000000000002','external_embed',0),
 ('30000000-0000-0000-0000-000000000018','40000000-0000-0000-0000-000000000003','external_embed',0)
on conflict do nothing;
