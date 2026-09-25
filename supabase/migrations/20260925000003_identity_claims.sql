-- Identity claims: relatives enter people first; the living person later
-- signs in and asks to be linked to their own record. Deceased records are
-- never claimable and are looked after by a caretaker or legacy contact.

create type public.claim_status_t as enum ('pending', 'approved', 'rejected', 'withdrawn');

alter table public.persons add column caretaker_id uuid references public.profiles (id) on delete set null;
comment on column public.persons.caretaker_id is 'Member who looks after this record when the person never used the app or has died.';
alter table public.profiles add column onboarding_done boolean not null default false;

create table public.claim_requests (
  id           uuid primary key default gen_random_uuid(),
  person_id    uuid not null references public.persons (id) on delete cascade,
  requester_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  status       public.claim_status_t not null default 'pending',
  message      text,
  reason       text,
  decided_by   uuid references public.profiles (id) on delete set null,
  decided_at   timestamptz,
  created_at   timestamptz not null default now()
);
create index claim_requests_person_idx on public.claim_requests (person_id, status);
create unique index claim_requests_one_pending on public.claim_requests (requester_id) where status = 'pending';

drop function if exists public.claim_person(uuid);

-- Who may approve a request for this person: admins, the record's creator,
-- and members linked to a person in the same family.
create function public.can_decide_claim(p uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select public.is_admin() or exists (
    select 1 from persons x
    where x.id = p and (x.created_by = auth.uid()
      or exists (select 1 from persons me where me.claimed_by = auth.uid() and me.family_id = x.family_id)));
$$;

-- Internal: link person and profile, fill gaps from the profile.
create function public.apply_claim(p uuid, who uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  update persons set claimed_by = who,
    email = coalesce(email, (select email from profiles where id = who))
  where id = p;
end $$;
revoke execute on function public.apply_claim(uuid, uuid) from authenticated;

create function public.notify_claim_approvers(p uuid, req uuid, requester uuid) returns void
language plpgsql security definer set search_path = public as $$
declare ids uuid[]; who text; me text;
begin
  select first_name || ' ' || last_name into who from persons where id = p;
  select coalesce(full_name, email) into me from profiles where id = requester;
  select array_agg(distinct u) into ids from (
    select created_by as u from persons where id = p
    union select claimed_by from persons where family_id = (select family_id from persons where id = p)
    union select id from profiles where is_admin and status = 'approved') s
  where u is not null and u <> requester;
  perform public.notify_users(ids, 'claim', me || ' says: this is me',
    'Please confirm that ' || me || ' is ' || who || '.', jsonb_build_object('claim_id', req, 'person_id', p));
end $$;
revoke execute on function public.notify_claim_approvers(uuid, uuid, uuid) from authenticated;

-- Ask to be linked to a record. Approved on the spot when the record was
-- created by the requester or carries their sign-in email; otherwise the
-- family confirms. Returns the resulting status.
create function public.request_claim(p uuid, message text default null) returns public.claim_status_t
language plpgsql security definer set search_path = public as $$
declare per persons; my_email text; req uuid;
begin
  if not public.is_approved() then raise exception 'not approved'; end if;
  select * into per from persons where id = p;
  if per.id is null then raise exception 'person not found'; end if;
  if not per.is_alive or per.dod is not null then raise exception 'this record is of someone who has passed away'; end if;
  if per.claimed_by is not null then raise exception 'this record is already linked to a member'; end if;
  if exists (select 1 from persons where claimed_by = auth.uid()) then
    raise exception 'you are already linked to a record; unlink it first';
  end if;
  if exists (select 1 from claim_requests where requester_id = auth.uid() and status = 'pending') then
    raise exception 'you already have a request waiting';
  end if;
  select email into my_email from profiles where id = auth.uid();
  insert into claim_requests (person_id, message) values (p, message) returning id into req;
  if per.created_by = auth.uid()
     or (my_email is not null and lower(coalesce(per.email, '')) = lower(my_email)) then
    -- mytail: phone match would need in-app OTP; only email and self-created records auto-approve.
    update claim_requests set status = 'approved', decided_by = auth.uid(), decided_at = now() where id = req;
    perform public.apply_claim(p, auth.uid());
    update profiles set onboarding_done = true where id = auth.uid();
    return 'approved';
  end if;
  perform public.notify_claim_approvers(p, req, auth.uid());
  return 'pending';
end $$;

create function public.decide_claim(request uuid, approve boolean, reason text default null) returns void
language plpgsql security definer set search_path = public as $$
declare r claim_requests; who text;
begin
  select * into r from claim_requests where id = request and status = 'pending';
  if r.id is null then raise exception 'request not found or already decided'; end if;
  if not public.can_decide_claim(r.person_id) then raise exception 'you cannot decide this request'; end if;
  if approve and exists (select 1 from persons where id = r.person_id and claimed_by is not null) then
    raise exception 'this record is already linked to a member';
  end if;
  update claim_requests set status = case when approve then 'approved'::claim_status_t else 'rejected' end,
    reason = decide_claim.reason, decided_by = auth.uid(), decided_at = now() where id = request;
  select first_name || ' ' || last_name into who from persons where id = r.person_id;
  if approve then
    perform public.apply_claim(r.person_id, r.requester_id);
    update profiles set onboarding_done = true where id = r.requester_id;
    perform public.notify_users(array[r.requester_id], 'claim', 'Your record is linked',
      'The family confirmed that you are ' || who || '.', jsonb_build_object('person_id', r.person_id));
  else
    perform public.notify_users(array[r.requester_id], 'claim', 'Request not confirmed',
      coalesce(reason, 'The family could not confirm that you are ' || who || '.'), jsonb_build_object('person_id', r.person_id));
  end if;
end $$;

create function public.withdraw_claim(request uuid) returns void
language sql security definer set search_path = public as $$
  update claim_requests set status = 'withdrawn', decided_at = now()
  where id = request and requester_id = auth.uid() and status = 'pending' and public.is_approved();
$$;

-- Unlink myself from my record.
create function public.release_claim() returns void
language sql security definer set search_path = public as $$
  update persons set claimed_by = null where claimed_by = auth.uid() and public.is_approved();
$$;

create function public.transfer_claim(p uuid, who uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not public.is_admin() then raise exception 'admin only'; end if;
  if exists (select 1 from persons where id = p and (not is_alive or dod is not null)) then
    raise exception 'this record is of someone who has passed away';
  end if;
  update persons set claimed_by = null where claimed_by = who;
  update persons set claimed_by = who where id = p;
end $$;

-- A member merges two records of themself (the one a relative made and the
-- one they made). Both must be theirs (created or linked).
create function public.merge_my_records(keep_id uuid, drop_id uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not public.is_approved() then raise exception 'not approved'; end if;
  if not exists (select 1 from persons where id = keep_id and (claimed_by = auth.uid() or created_by = auth.uid()))
     or not exists (select 1 from persons where id = drop_id and (claimed_by = auth.uid() or created_by = auth.uid())) then
    raise exception 'both records must be yours';
  end if;
  -- merge_persons is admin-only; run the same steps here under our own check.
  update persons k set
    middle_name = coalesce(k.middle_name, d.middle_name), nickname = coalesce(k.nickname, d.nickname),
    dob = coalesce(k.dob, d.dob), birth_place = coalesce(k.birth_place, d.birth_place),
    birth_lat = coalesce(k.birth_lat, d.birth_lat), birth_lng = coalesce(k.birth_lng, d.birth_lng),
    current_place = coalesce(k.current_place, d.current_place),
    current_lat = coalesce(k.current_lat, d.current_lat), current_lng = coalesce(k.current_lng, d.current_lng),
    native_village = coalesce(k.native_village, d.native_village), gotra_id = coalesce(k.gotra_id, d.gotra_id),
    phones = (select coalesce(jsonb_agg(distinct x), '[]') from jsonb_array_elements(k.phones || d.phones) x),
    email = coalesce(k.email, d.email), occupation = coalesce(k.occupation, d.occupation),
    education = coalesce(k.education, d.education), biography = coalesce(k.biography, d.biography),
    notes = coalesce(k.notes, d.notes), passport_photo_path = coalesce(k.passport_photo_path, d.passport_photo_path)
  from persons d where k.id = keep_id and d.id = drop_id;
  update persons set claimed_by = null where id = drop_id;
  update persons set claimed_by = auth.uid() where id = keep_id and claimed_by is null;
  update relationships r set person_id = keep_id where r.person_id = drop_id and r.related_id <> keep_id
    and not exists (select 1 from relationships x where x.kind = r.kind and x.person_id = keep_id and x.related_id = r.related_id);
  update relationships r set related_id = keep_id where r.related_id = drop_id and r.person_id <> keep_id
    and not exists (select 1 from relationships x where x.kind = r.kind and x.person_id = r.person_id and x.related_id = keep_id);
  delete from relationships where person_id = drop_id or related_id = drop_id;
  update life_events set person_id = keep_id where person_id = drop_id;
  update media set person_id = keep_id where person_id = drop_id;
  update albums set person_id = keep_id where person_id = drop_id;
  delete from claim_requests where person_id = drop_id;
  delete from persons where id = drop_id;
end $$;

-- Guided "are you already in the tree?" search: living, unlinked people
-- scored on name, birth year, village, phone and email, with parents' names.
create function public.find_myself(first_name text, last_name text, village text default null, birth_year integer default null, phone text default null)
returns table (person_id uuid, score integer, parents text)
language sql stable security definer set search_path = public as $$
  with me as (select lower(trim(find_myself.first_name)) fn, lower(trim(find_myself.last_name)) ln,
                     lower(nullif(trim(find_myself.village), '')) vil, find_myself.birth_year yr,
                     nullif(trim(find_myself.phone), '') ph,
                     lower((select email from profiles where id = auth.uid())) em),
  scored as (
    select p.id,
      (case when lower(p.first_name) = me.fn then 40 when me.fn <> '' and left(lower(p.first_name), 4) = left(me.fn, 4) then 20 else 0 end)
      + (case when lower(p.last_name) = me.ln or lower(coalesce(p.maiden_name, '')) = me.ln then 20 else 0 end)
      + (case when me.yr is not null and p.dob is not null and abs(extract(year from p.dob) - me.yr) <= 1 then 25 else 0 end)
      + (case when me.vil is not null and lower(coalesce(p.native_village, '')) = me.vil then 15 else 0 end)
      + (case when me.ph is not null and p.phones::text like '%' || me.ph || '%' then 40 else 0 end)
      + (case when me.em is not null and lower(coalesce(p.email, '')) = me.em then 60 else 0 end) as score
    from persons p, me
    where p.is_alive and p.dod is null and p.claimed_by is null)
  select s.id, least(s.score, 100),
    (select string_agg(par.first_name || ' ' || par.last_name, ', ')
     from relationships r join persons par on par.id = r.person_id where r.kind = 'parent' and r.related_id = s.id)
  from scored s where public.is_approved() and s.score >= 40
  order by s.score desc limit 15;
$$;

-- Marking a linked, living person as deceased needs an admin, so nobody is
-- locked out by mistake. When it happens, the link is released and the
-- legacy contact (or existing caretaker) takes over.
create function public.guard_deceased() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if old.is_alive and not new.is_alive and old.claimed_by is not null then
    if not public.is_admin() then
      raise exception 'ask an admin to confirm that this member has passed away';
    end if;
    new.caretaker_id := coalesce(new.caretaker_id, (select successor_id from profiles where id = old.claimed_by));
    new.claimed_by := null;
    update claim_requests set status = 'withdrawn', decided_at = now() where person_id = new.id and status = 'pending';
  end if;
  return new;
end $$;
create trigger persons_guard_deceased before update of is_alive on public.persons for each row execute function public.guard_deceased();

-- Caretaker: creator, admin or current caretaker may assign.
create function public.set_caretaker(p uuid, who uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not public.is_approved() then raise exception 'not approved'; end if;
  if not exists (select 1 from persons where id = p and (created_by = auth.uid() or caretaker_id = auth.uid() or public.is_admin())) then
    raise exception 'only the record''s creator, its caretaker or an admin can do this';
  end if;
  update persons set caretaker_id = who where id = p;
end $$;

-- can_edit_person keeps being the "maintainer" notion for deceased records.
create or replace function public.can_edit_person(p uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from persons pe
    left join profiles owner on owner.id = pe.claimed_by
    where pe.id = p and (
      pe.created_by = auth.uid() or pe.claimed_by = auth.uid() or pe.caretaker_id = auth.uid()
      or public.is_admin()
      or (not pe.is_alive and owner.successor_id = auth.uid())));
$$;

alter table public.claim_requests enable row level security;
create policy claims_select on public.claim_requests for select to authenticated
  using (requester_id = auth.uid() or public.can_decide_claim(person_id));
