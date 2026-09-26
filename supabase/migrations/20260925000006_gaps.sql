-- Gap fixes: notifications carry data the app can localise, admins hear
-- about new sign-ups, a "passing away" event marks the person deceased,
-- duplicate matching reads both scripts, bulk match check, large text.

alter table public.profiles add column large_text boolean not null default false;

-- ------------------------------------------------ localisable notifications
-- Titles/bodies stay as English fallbacks; `data` now has what the app needs
-- to render the message in the reader's language.
create or replace function public.on_life_event() returns trigger
language plpgsql security definer set search_path = public as $$
declare who persons; ids uuid[];
begin
  if new.kind in ('birth', 'marriage', 'death') then
    select * into who from persons where id = new.person_id;
    select array_agg(id) into ids from profiles where status = 'approved' and id is distinct from auth.uid();
    perform public.notify_users(ids, 'event', initcap(new.kind::text) || ': ' || who.first_name || ' ' || who.last_name,
      coalesce(new.title, ''),
      jsonb_build_object('person_id', new.person_id, 'event_id', new.id, 'event_kind', new.kind,
        'person_name', who.first_name || ' ' || who.last_name,
        'person_name_en', nullif(concat_ws(' ', who.first_name_en, who.last_name_en), ''),
        'event_title', new.title));
  end if;
  -- A recorded passing marks the person deceased (admin guard applies for linked people).
  if new.kind = 'death' then
    update persons set is_alive = false, dod = coalesce(dod, new.event_date) where id = new.person_id and is_alive;
  end if;
  return new;
end $$;

create or replace function public.on_profile_status_change() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if new.status = 'approved' and old.status <> 'approved' then
    perform public.notify_users(array[new.id], 'membership', 'Welcome to the Samaj',
      'Your membership has been approved. You can now build your family tree.', jsonb_build_object('subkind', 'approved'));
  end if;
  return new;
end $$;

-- New sign-up: tell the admins.
create function public.on_profile_created() returns trigger
language plpgsql security definer set search_path = public as $$
declare ids uuid[];
begin
  if new.status = 'pending' then
    select array_agg(id) into ids from profiles where is_admin and status = 'approved';
    perform public.notify_users(ids, 'membership', 'New member waiting',
      coalesce(new.full_name, new.email, '?') || ' wants to join the Samaj.',
      jsonb_build_object('subkind', 'new_member', 'member_name', coalesce(new.full_name, new.email, '?')));
  end if;
  return new;
end $$;
create trigger profiles_created_notify after insert on public.profiles for each row execute function public.on_profile_created();

create or replace function public.on_match_suggestion() returns trigger
language plpgsql security definer set search_path = public as $$
declare ids uuid[];
begin
  select array_agg(distinct u) into ids from (
    select claimed_by as u from persons where id in (new.person_id, new.candidate_id)
    union select created_by from persons where id in (new.person_id, new.candidate_id)) s where u is not null;
  perform public.notify_users(ids, 'match', 'Possible match found',
    'Two profiles may be the same person. Review in Matches.', jsonb_build_object('suggestion_id', new.id));
  return new;
end $$;

create or replace function public.on_message() returns trigger
language plpgsql security definer set search_path = public as $$
declare ids uuid[]; who text;
begin
  select coalesce(full_name, email) into who from profiles where id = new.sender_id;
  select array_agg(user_id) into ids from conversation_participants
  where conversation_id = new.conversation_id and user_id <> new.sender_id;
  perform public.notify_users(ids, 'chat', coalesce(who, 'New message'), left(new.body, 120),
    jsonb_build_object('conversation_id', new.conversation_id, 'sender_name', who, 'preview', left(new.body, 120)));
  return new;
end $$;

create or replace function public.on_ticket_change() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if new.status is distinct from old.status then
    perform public.notify_users(array[new.user_id], 'support', 'Support ticket ' || new.status::text,
      new.subject, jsonb_build_object('ticket_id', new.id, 'subkind', 'status', 'status', new.status, 'subject', new.subject));
  end if;
  return new;
end $$;

create or replace function public.on_support_message() returns trigger
language plpgsql security definer set search_path = public as $$
declare owner uuid;
begin
  select user_id into owner from support_tickets where id = new.ticket_id;
  if owner <> new.sender_id then
    perform public.notify_users(array[owner], 'support', 'Reply on your support ticket',
      left(new.body, 120), jsonb_build_object('ticket_id', new.ticket_id, 'subkind', 'reply', 'preview', left(new.body, 120)));
  end if;
  return new;
end $$;

create or replace function public.notify_claim_approvers(p uuid, req uuid, requester uuid) returns void
language plpgsql security definer set search_path = public as $$
declare ids uuid[]; who persons; me text;
begin
  select * into who from persons where id = p;
  select coalesce(full_name, email) into me from profiles where id = requester;
  select array_agg(distinct u) into ids from (
    select created_by as u from persons where id = p
    union select claimed_by from persons where family_id = who.family_id
    union select id from profiles where is_admin and status = 'approved') s
  where u is not null and u <> requester;
  perform public.notify_users(ids, 'claim', me || ' says: this is me',
    'Please confirm that ' || me || ' is ' || who.first_name || ' ' || who.last_name || '.',
    jsonb_build_object('claim_id', req, 'person_id', p, 'subkind', 'request', 'requester_name', me,
      'person_name', who.first_name || ' ' || who.last_name, 'person_name_en', nullif(concat_ws(' ', who.first_name_en, who.last_name_en), '')));
end $$;

create or replace function public.decide_claim(request uuid, approve boolean, reason text default null) returns void
language plpgsql security definer set search_path = public as $$
declare r claim_requests; who persons; d jsonb;
begin
  select * into r from claim_requests where id = request and status = 'pending';
  if r.id is null then raise exception 'request not found or already decided'; end if;
  if not public.can_decide_claim(r.person_id) then raise exception 'you cannot decide this request'; end if;
  if approve and exists (select 1 from persons where id = r.person_id and claimed_by is not null) then
    raise exception 'this record is already linked to a member';
  end if;
  update claim_requests set status = case when approve then 'approved'::claim_status_t else 'rejected' end,
    reason = decide_claim.reason, decided_by = auth.uid(), decided_at = now() where id = request;
  select * into who from persons where id = r.person_id;
  d := jsonb_build_object('person_id', r.person_id, 'person_name', who.first_name || ' ' || who.last_name,
         'person_name_en', nullif(concat_ws(' ', who.first_name_en, who.last_name_en), ''), 'reason', reason);
  if approve then
    perform public.apply_claim(r.person_id, r.requester_id);
    update profiles set onboarding_done = true where id = r.requester_id;
    perform public.notify_users(array[r.requester_id], 'claim', 'Your record is linked',
      'The family confirmed that you are ' || who.first_name || ' ' || who.last_name || '.', d || '{"subkind": "approved"}');
  else
    perform public.notify_users(array[r.requester_id], 'claim', 'Request not confirmed',
      coalesce(reason, 'The family could not confirm that you are ' || who.first_name || ' ' || who.last_name || '.'), d || '{"subkind": "rejected"}');
  end if;
end $$;

-- ------------------------------------------------ matches in both scripts
create or replace function public.find_matches(p uuid)
returns table (candidate_id uuid, score integer, reasons text[])
language sql stable security definer set search_path = public as $$
  with me as (select * from persons where id = p),
  scored as (
    select c.id,
      (case when lower(c.first_name) = lower(me.first_name)
              or (c.first_name_en is not null and lower(c.first_name_en) = lower(coalesce(me.first_name_en, '')))
              or lower(c.first_name) = lower(coalesce(me.first_name_en, '')) or lower(coalesce(c.first_name_en, '')) = lower(me.first_name) then 40
            when left(lower(c.first_name), 3) = left(lower(me.first_name), 3)
              or (c.first_name_en is not null and me.first_name_en is not null and left(lower(c.first_name_en), 4) = left(lower(me.first_name_en), 4)) then 20 else 0 end)
      + (case when lower(c.last_name) = lower(me.last_name)
                or (c.last_name_en is not null and lower(c.last_name_en) = lower(coalesce(me.last_name_en, '')))
                or lower(coalesce(c.maiden_name, '')) = lower(me.last_name)
                or lower(coalesce(me.maiden_name, '')) = lower(c.last_name) then 20 else 0 end)
      + (case when c.dob is not null and me.dob is not null then
              case when c.dob = me.dob then 30
                   when abs(extract(year from c.dob) - extract(year from me.dob)) <= 1 then 15 else 0 end
         else 0 end)
      + (case when lower(coalesce(c.native_village, '')) = lower(coalesce(me.native_village, '-')) then 10 else 0 end)
      as score,
      array_remove(array[
        case when lower(c.first_name) = lower(me.first_name) or lower(coalesce(c.first_name_en, '-')) = lower(coalesce(me.first_name_en, '')) then 'same first name' end,
        case when lower(c.last_name) = lower(me.last_name) or lower(coalesce(c.last_name_en, '-')) = lower(coalesce(me.last_name_en, '')) then 'same surname' end,
        case when c.dob is not null and c.dob = me.dob then 'same date of birth' end,
        case when lower(coalesce(c.native_village, '')) = lower(coalesce(me.native_village, '-')) then 'same native village' end
      ], null) as reasons
    from persons c, me
    where c.id <> me.id and c.gender = me.gender and c.family_id <> me.family_id)
  select id, least(score, 100), reasons from scored
  where public.is_approved() and score >= 50
  order by score desc limit 20;
$$;
revoke execute on function public.find_matches(uuid) from public, anon, authenticated;

-- Admin: check everyone at once. mytail: O(n^2) name compare; fine to a few
-- thousand people, run from the admin screen, not on a timer.
create function public.refresh_all_matches() returns integer
language plpgsql security definer set search_path = public as $$
declare pid uuid; total integer := 0;
begin
  if not public.is_admin() then raise exception 'admin only'; end if;
  for pid in select id from persons loop
    total := total + public.refresh_matches(pid);
  end loop;
  return total;
end $$;

-- Lock down (EXECUTE-to-PUBLIC default, see 0004).
revoke execute on function public.refresh_all_matches() from public, anon;
grant execute on function public.refresh_all_matches() to authenticated;
revoke execute on function public.on_profile_created() from public, anon, authenticated;
