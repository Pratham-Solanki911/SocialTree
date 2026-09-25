-- Smoke test for the schema: bootstrap admin, approvals, tree integrity,
-- tree queries, matches + merge, open editing, legacy successor, PDF data.
-- Expected-failure blocks raise a sentinel if the statement wrongly succeeds.
\set ON_ERROR_STOP on
\set u1 '00000000-0000-0000-0000-000000000001'
\set u2 '00000000-0000-0000-0000-000000000002'
\set u3 '00000000-0000-0000-0000-000000000003'

insert into auth.users (id, email, raw_user_meta_data) values
  (:'u1', 'admin@example.com',  '{"full_name":"Admin Suthar"}'),
  (:'u2', 'ramesh@example.com', '{"full_name":"Ramesh Suthar"}'),
  (:'u3', 'nita@example.com',   '{"full_name":"Nita Suthar"}');

do $$ begin
  assert (select is_admin and status = 'approved' from public.profiles where id = '00000000-0000-0000-0000-000000000001'), 'first user is bootstrap admin';
  assert (select status = 'pending' from public.profiles where id = '00000000-0000-0000-0000-000000000002'), 'later users start pending';
end $$;

-- admin approves the others
set role authenticated;
select set_config('request.jwt.claim.sub', :'u1', false);
update public.profiles set status = 'approved' where id in (:'u2', :'u3');
reset role;
do $$ begin
  assert (select count(*) from public.notifications where user_id = '00000000-0000-0000-0000-000000000002' and kind = 'membership') = 1, 'welcome notification';
end $$;

-- user 2 (member) cannot promote themself
set role authenticated;
select set_config('request.jwt.claim.sub', :'u2', false);
do $$ begin
  update public.profiles set is_admin = true where id = '00000000-0000-0000-0000-000000000002';
  raise exception 'sentinel';
exception when others then
  if sqlerrm = 'sentinel' then raise exception 'self-promotion should have failed'; end if;
end $$;

-- families and people
insert into public.families (id, name, surname, native_village) values
  ('f0000000-0000-0000-0000-000000000001', 'Solanki parivar, Morbi', 'Solanki', 'Morbi'),
  ('f0000000-0000-0000-0000-000000000002', 'Rathod parivar, Wankaner', 'Rathod', 'Wankaner');

insert into public.persons (id, family_id, first_name, last_name, gender, dob, native_village, gotra_id, phones,
                            birth_place, birth_lat, birth_lng, current_place, current_lat, current_lng) values
  ('a0000000-0000-0000-0000-00000000000a', 'f0000000-0000-0000-0000-000000000001', 'Govind', 'Solanki', 'male',   '1940-01-01', 'Morbi', (select id from public.gotras where name = 'Khodiyar'), '[]', 'Morbi', 22.81, 70.83, 'Morbi', 22.81, 70.83),
  ('a0000000-0000-0000-0000-00000000000b', 'f0000000-0000-0000-0000-000000000001', 'Bharat', 'Solanki', 'male',   '1965-05-05', 'Morbi', null, '[]', 'Morbi', 22.81, 70.83, 'Rajkot', 22.30, 70.80),
  ('a0000000-0000-0000-0000-00000000000c', 'f0000000-0000-0000-0000-000000000001', 'Manju',  'Solanki', 'female', '1968-02-02', 'Morbi', null, '[]', null, null, null, null, null, null),
  ('a0000000-0000-0000-0000-00000000000d', 'f0000000-0000-0000-0000-000000000001', 'Ramesh', 'Solanki', 'male',   '1990-03-03', 'Morbi', null,
     '[{"number":"+919876543210","label":"mobile","whatsapp":true},{"number":"+447700900123","label":"UK","whatsapp":true}]', 'Rajkot', 22.30, 70.80, 'London', 51.50, -0.12),
  ('a0000000-0000-0000-0000-00000000000e', 'f0000000-0000-0000-0000-000000000001', 'Sunita', 'Solanki', 'female', '1993-04-04', 'Morbi', null, '[]', null, null, null, null, null, null),
  ('a0000000-0000-0000-0000-00000000000f', 'f0000000-0000-0000-0000-000000000002', 'Nita',   'Rathod',  'female', '1991-06-06', 'Wankaner', null, '[]', null, null, null, null, null, null),
  ('a0000000-0000-0000-0000-000000000010', 'f0000000-0000-0000-0000-000000000001', 'Aarav',  'Solanki', 'male',   '2018-07-07', 'Morbi', null, '[]', null, null, null, null, null, null);

-- bad phone rejected
do $$ begin
  insert into public.persons (family_id, first_name, last_name, gender, phones)
  values ('f0000000-0000-0000-0000-000000000001', 'Bad', 'Phone', 'male', '[{"number":"98765"}]');
  raise exception 'sentinel';
exception when others then
  if sqlerrm = 'sentinel' then raise exception 'invalid phone should have failed'; end if;
end $$;

insert into public.relationships (kind, person_id, related_id) values
  ('parent', 'a0000000-0000-0000-0000-00000000000a', 'a0000000-0000-0000-0000-00000000000b'),
  ('parent', 'a0000000-0000-0000-0000-00000000000b', 'a0000000-0000-0000-0000-00000000000d'),
  ('parent', 'a0000000-0000-0000-0000-00000000000c', 'a0000000-0000-0000-0000-00000000000d'),
  ('parent', 'a0000000-0000-0000-0000-00000000000b', 'a0000000-0000-0000-0000-00000000000e'),
  ('parent', 'a0000000-0000-0000-0000-00000000000c', 'a0000000-0000-0000-0000-00000000000e'),
  ('spouse', 'a0000000-0000-0000-0000-00000000000f', 'a0000000-0000-0000-0000-00000000000d'),  -- inserted reversed on purpose
  ('parent', 'a0000000-0000-0000-0000-00000000000d', 'a0000000-0000-0000-0000-000000000010'),
  ('parent', 'a0000000-0000-0000-0000-00000000000f', 'a0000000-0000-0000-0000-000000000010');

do $$ begin
  assert (select person_id < related_id from public.relationships where kind = 'spouse'), 'spouse edge stored in canonical order';
  -- gotra inherited down the male line: Govind -> Bharat -> Ramesh
  assert (select g.name from public.persons p join public.gotras g on g.id = p.gotra_id where p.id = 'a0000000-0000-0000-0000-00000000000d') = 'Khodiyar', 'gotra inherited';
end $$;

-- cycle: Aarav cannot be Govind's parent
do $$ begin
  insert into public.relationships (kind, person_id, related_id) values ('parent', 'a0000000-0000-0000-0000-000000000010', 'a0000000-0000-0000-0000-00000000000a');
  raise exception 'sentinel';
exception when others then
  if sqlerrm = 'sentinel' then raise exception 'cycle should have failed'; end if;
end $$;
-- third parent rejected
do $$ begin
  insert into public.relationships (kind, person_id, related_id) values ('parent', 'a0000000-0000-0000-0000-00000000000e', 'a0000000-0000-0000-0000-000000000010');
  raise exception 'sentinel';
exception when others then
  if sqlerrm = 'sentinel' then raise exception 'third parent should have failed'; end if;
end $$;

-- tree queries
do $$
declare t jsonb;
begin
  t := public.get_tree('a0000000-0000-0000-0000-00000000000d', 3);
  assert jsonb_array_length(t -> 'persons') = 7, 'get_tree persons: ' || jsonb_array_length(t -> 'persons');
  assert jsonb_array_length(t -> 'relationships') = 8, 'get_tree relationships';
  assert (select count(*) from public.get_ancestors('a0000000-0000-0000-0000-00000000000d')) = 3, 'ancestors of Ramesh';
  assert (select count(*) from public.get_descendants('a0000000-0000-0000-0000-00000000000a')) = 4, 'descendants of Govind';
  assert (select count(*) from public.search_persons('ram sol')) = 1, 'prefix search';
  assert (select count(*) from public.search_persons('')) = 0, 'empty search';
end $$;

-- matches: a duplicate Ramesh in the Rathod family
insert into public.persons (id, family_id, first_name, last_name, gender, dob, native_village)
values ('a0000000-0000-0000-0000-000000000011', 'f0000000-0000-0000-0000-000000000002', 'Ramesh', 'Solanki', 'male', '1990-03-03', 'Morbi');
do $$ begin
  assert (select score from public.find_matches('a0000000-0000-0000-0000-00000000000d')) = 100, 'match score';
  assert public.refresh_matches('a0000000-0000-0000-0000-00000000000d') = 1, 'one suggestion stored';
end $$;

-- migration map: Ramesh has birth, one migration event, current place
insert into public.life_events (person_id, kind, title, event_date, place, lat, lng)
values ('a0000000-0000-0000-0000-00000000000d', 'migration', 'Moved to Ahmedabad', '2010-06-01', 'Ahmedabad', 23.02, 72.57);
do $$ begin
  assert (select count(*) from public.migration_paths() where person_id = 'a0000000-0000-0000-0000-00000000000d') = 3, 'migration hops';
  assert (select place from public.migration_paths() where person_id = 'a0000000-0000-0000-0000-00000000000d' and seq = 2) = 'Ahmedabad', 'hop order';
end $$;

-- death event fans out to everyone except the author
insert into public.life_events (person_id, kind, title, event_date) values ('a0000000-0000-0000-0000-00000000000a', 'death', 'Passed away peacefully', '2020-01-15');

-- albums, photos and linked videos are open to every member
insert into public.albums (id, title, family_id) values ('b0000000-0000-0000-0000-000000000001', 'Morbi 2019', 'f0000000-0000-0000-0000-000000000001');
insert into public.albums (title, family_id) values ('Second album', 'f0000000-0000-0000-0000-000000000001');
insert into public.media (kind, album_id, storage_path, mime_type, size_bytes) values ('photo', 'b0000000-0000-0000-0000-000000000001', 'albums/b0000000-0000-0000-0000-000000000001/x.jpg', 'image/jpeg', 120000);
insert into public.media (kind, album_id, external_url) values ('video', 'b0000000-0000-0000-0000-000000000001', 'https://youtu.be/abc');

-- members can correct kuldevi/kuldevta; only admins can mark verified
update public.gotras set kuldevi = 'Shri Khodiyar Mata (Matel)', verified = true where name = 'Khodiyar';
do $$ begin
  assert (select kuldevi = 'Shri Khodiyar Mata (Matel)' and not verified from public.gotras where name = 'Khodiyar'), 'member edit saved, unverified';
end $$;
update public.persons set kuldevi = 'Khodiyar Mata, Rajpara' where id = 'a0000000-0000-0000-0000-00000000000d';

-- claim + export
select public.claim_person('a0000000-0000-0000-0000-00000000000d');
do $$
declare t jsonb;
begin
  t := public.get_tree_pdf_data('a0000000-0000-0000-0000-00000000000d', 5, 5);
  assert jsonb_array_length(t -> 'persons') = 7, 'pdf data persons: ' || jsonb_array_length(t -> 'persons');
  assert (select x ->> 'gen' from jsonb_array_elements(t -> 'persons') x where x ->> 'id' = 'a0000000-0000-0000-0000-00000000000a') = '-2', 'grandfather at gen -2';
  assert (select x ->> 'gen' from jsonb_array_elements(t -> 'persons') x where x ->> 'id' = 'a0000000-0000-0000-0000-00000000000f') = '0', 'spouse on root generation';
  assert (select x ->> 'gen' from jsonb_array_elements(t -> 'persons') x where x ->> 'id' = 'a0000000-0000-0000-0000-00000000000e') = '0', 'sibling on root generation';
  assert (select x ->> 'gotra_name' from jsonb_array_elements(t -> 'persons') x where x ->> 'id' = 'a0000000-0000-0000-0000-00000000000d') = 'Khodiyar', 'gotra name joined';
  assert jsonb_array_length(t -> 'relationships') = 8, 'pdf data edges';
end $$;
do $$ begin
  perform public.claim_person('a0000000-0000-0000-0000-00000000000e');
  raise exception 'sentinel';
exception when others then
  if sqlerrm = 'sentinel' then raise exception 'second claim should have failed'; end if;
end $$;

-- admin merges the duplicate; any member can start a chat
select set_config('request.jwt.claim.sub', :'u1', false);
select public.merge_persons('a0000000-0000-0000-0000-00000000000d', 'a0000000-0000-0000-0000-000000000011');
select set_config('request.jwt.claim.sub', :'u2', false);
do $$
declare cid uuid;
begin
  cid := public.get_or_create_direct_conversation('00000000-0000-0000-0000-000000000003');
  assert cid = public.get_or_create_direct_conversation('00000000-0000-0000-0000-000000000003'), 'conversation reused';
  insert into public.messages (conversation_id, body) values (cid, 'Kem cho?');
end $$;
-- the other member replies
select set_config('request.jwt.claim.sub', :'u3', false);
insert into public.messages (conversation_id, body)
select conversation_id, 'Majama!' from public.conversation_participants where user_id = :'u3';

-- support: admin tickets are high priority, members normal
select set_config('request.jwt.claim.sub', :'u2', false);
insert into public.support_tickets (id, subject, body) values ('c0000000-0000-0000-0000-000000000001', 'Cannot upload photo', 'Fails on my phone');
select set_config('request.jwt.claim.sub', :'u3', false);
insert into public.support_tickets (id, subject, body) values ('c0000000-0000-0000-0000-000000000002', 'Question', 'How do I add my uncle?');
select set_config('request.jwt.claim.sub', :'u1', false);
insert into public.support_tickets (id, subject, body) values ('c0000000-0000-0000-0000-000000000003', 'Admin note', 'Checking priority');
update public.support_tickets set status = 'resolved' where id = 'c0000000-0000-0000-0000-000000000001';

-- records are maintained together: another member can edit Ramesh
select set_config('request.jwt.claim.sub', :'u2', false);
update public.profiles set successor_id = :'u3' where id = :'u2';
select set_config('request.jwt.claim.sub', :'u3', false);
do $$
declare n integer;
begin
  update public.persons set current_place = 'Leicester' where id = 'a0000000-0000-0000-0000-00000000000d';
  get diagnostics n = row_count;
  assert n = 1, 'any approved member edits a person';
  update public.families set native_village = 'Morbi (Machhu)' where id = 'f0000000-0000-0000-0000-000000000001';
  get diagnostics n = row_count;
  assert n = 1, 'any approved member edits a family';
end $$;

select set_config('request.jwt.claim.sub', :'u1', false);
update public.gotras set verified = true where name = 'Khodiyar';
reset role;
do $$ begin
  assert (select verified from public.gotras where name = 'Khodiyar'), 'admin verified gotra';
  assert (select count(*) from public.notifications where kind = 'event' and title like 'Death: Govind%') = 2, 'death fan-out to two others';
  assert (select count(*) from public.notifications where kind = 'match') >= 1, 'match notification';
  assert (select count(*) from public.notifications where kind = 'chat' and user_id = '00000000-0000-0000-0000-000000000003') = 1, 'chat notification';
  assert (select count(*) from public.notifications where kind = 'support' and user_id = '00000000-0000-0000-0000-000000000002') = 1, 'support notification';
  assert (select priority from public.support_tickets where id = 'c0000000-0000-0000-0000-000000000001') = 'normal', 'member ticket is normal priority';
  assert (select priority from public.support_tickets where id = 'c0000000-0000-0000-0000-000000000003') = 'high', 'admin ticket is high priority';
  assert (select locale is null from public.profiles where id = '00000000-0000-0000-0000-000000000003'), 'locale unset until first-login choice';
  assert not exists (select 1 from pg_type where typname = 'plan_t'), 'plan type dropped';
  assert not exists (select 1 from public.persons where id = 'a0000000-0000-0000-0000-000000000011'), 'duplicate merged away';
  assert (select count(*) from public.relationships where person_id = 'a0000000-0000-0000-0000-00000000000d' or related_id = 'a0000000-0000-0000-0000-00000000000d') = 4, 'edges survive merge';
  assert not exists (select 1 from public.match_suggestions where status = 'pending'), 'no pending suggestion after merge';
end $$;
