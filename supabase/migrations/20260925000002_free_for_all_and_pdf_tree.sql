-- 1. No plans: every approved member gets every feature.
-- 2. JSON export replaced by a tree-PDF data function.
-- 3. Locale is chosen on first login (null until then).

-- ---------------------------------------------------------------- plans out
drop trigger if exists albums_plan_limit on public.albums;
drop function if exists public.guard_album_insert();

drop policy if exists media_insert on public.media;
create policy media_insert on public.media for insert to authenticated
  with check (public.is_approved() and uploaded_by = auth.uid());

create or replace function public.get_or_create_direct_conversation(other uuid) returns uuid
language plpgsql security definer set search_path = public as $$
declare cid uuid;
begin
  if not public.is_approved() then raise exception 'not approved'; end if;
  if other = auth.uid() then raise exception 'cannot chat with yourself'; end if;
  if not exists (select 1 from profiles where id = other and status = 'approved') then
    raise exception 'user is not an approved member';
  end if;
  select c.id into cid from conversations c
  where (select count(*) from conversation_participants cp where cp.conversation_id = c.id) = 2
    and exists (select 1 from conversation_participants cp where cp.conversation_id = c.id and cp.user_id = auth.uid())
    and exists (select 1 from conversation_participants cp where cp.conversation_id = c.id and cp.user_id = other)
  limit 1;
  if cid is null then
    insert into conversations (created_by) values (auth.uid()) returning id into cid;
    insert into conversation_participants (conversation_id, user_id) values (cid, auth.uid()), (cid, other);
  end if;
  return cid;
end $$;

create or replace function public.guard_profile_update() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if public.is_admin() then return new; end if;
  if new.status is distinct from old.status
     or new.is_admin is distinct from old.is_admin
     or new.is_support is distinct from old.is_support
     or new.approved_by is distinct from old.approved_by
     or new.approved_at is distinct from old.approved_at then
    raise exception 'only admins can change status or roles';
  end if;
  return new;
end $$;

-- Admin tickets are handled first; everyone else is equal.
create or replace function public.set_ticket_priority() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  new.priority := case when exists (select 1 from profiles where id = new.user_id and is_admin)
                       then 'high'::ticket_priority_t else 'normal' end;
  return new;
end $$;

drop function if exists public.has_plan(public.plan_t);
alter table public.profiles drop column if exists plan;
drop type if exists public.plan_t;

-- ------------------------------------------------------------ export -> PDF
drop function if exists public.export_my_data();

-- Persons and edges for a printable tree: `up` generations of ancestors and
-- `down` generations of descendants from root, widened with the spouses and
-- siblings (and their spouses) of everyone included.
create or replace function public.get_tree_pdf_data(root uuid, up integer default 5, down integer default 5) returns jsonb
language sql stable security definer set search_path = public as $$
  with recursive anc as (
    select root as id, 0 as gen
    union
    select r.person_id, anc.gen - 1 from relationships r join anc on r.related_id = anc.id
    where r.kind = 'parent' and anc.gen > -least(up, 12)
  ), des as (
    select root as id, 0 as gen
    union
    select r.related_id, des.gen + 1 from relationships r join des on r.person_id = des.id
    where r.kind = 'parent' and des.gen < least(down, 12)
  ), line as (select id, gen from anc union select id, gen from des),
  sib as (  -- siblings share a parent with someone on the line
    select distinct c.related_id as id, l.gen
    from line l join relationships p on p.kind = 'parent' and p.related_id = l.id
    join relationships c on c.kind = 'parent' and c.person_id = p.person_id
  ),
  core as (select id, min(gen) as gen from (select * from line union select * from sib) x group by id),
  sp as (  -- spouses sit on their partner's generation
    select distinct case when r.person_id = c.id then r.related_id else r.person_id end as id, c.gen
    from core c join relationships r on r.kind = 'spouse' and (r.person_id = c.id or r.related_id = c.id)
  ),
  allp as (select id, min(gen) as gen from (select * from core union select * from sp) y group by id)
  select jsonb_build_object(
    'root', root,
    'persons', coalesce((select jsonb_agg((to_jsonb(p) - 'search') || jsonb_build_object('gen', a.gen, 'gotra_name', g.name, 'family_name', f.name) order by a.gen, p.last_name, p.first_name)
                         from allp a join persons p on p.id = a.id left join gotras g on g.id = p.gotra_id left join families f on f.id = p.family_id), '[]'),
    'relationships', coalesce((select jsonb_agg(to_jsonb(r)) from relationships r
                         where r.person_id in (select id from allp) and r.related_id in (select id from allp)), '[]'))
  where public.is_approved();
$$;

-- ---------------------------------------------------------- first-login locale
alter table public.profiles alter column locale drop not null;
alter table public.profiles alter column locale drop default;
-- Existing members already chose implicitly; leave them on 'en'.

-- ------------------------------------------------- everything editable
-- The samaj maintains records together: any approved member may edit any
-- person, relationship, event or family. Deletes stay with admins/creators.
drop policy if exists persons_update on public.persons;
create policy persons_update on public.persons for update to authenticated using (public.is_approved());
drop policy if exists relationships_insert on public.relationships;
create policy relationships_insert on public.relationships for insert to authenticated
  with check (public.is_approved() and created_by = auth.uid());
drop policy if exists relationships_update on public.relationships;
create policy relationships_update on public.relationships for update to authenticated using (public.is_approved());
drop policy if exists relationships_delete on public.relationships;
create policy relationships_delete on public.relationships for delete to authenticated using (public.is_approved());
drop policy if exists life_events_insert on public.life_events;
create policy life_events_insert on public.life_events for insert to authenticated
  with check (public.is_approved() and created_by = auth.uid());
drop policy if exists life_events_update on public.life_events;
create policy life_events_update on public.life_events for update to authenticated using (public.is_approved());
drop policy if exists life_events_delete on public.life_events;
create policy life_events_delete on public.life_events for delete to authenticated using (public.is_approved());
drop policy if exists families_update on public.families;
create policy families_update on public.families for update to authenticated using (public.is_approved());
drop policy if exists albums_update on public.albums;
create policy albums_update on public.albums for update to authenticated using (public.is_approved());
