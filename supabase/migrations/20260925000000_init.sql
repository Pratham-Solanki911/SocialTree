-- SocialTree: Shri Machhukathiya Sai Suthar Samaj family-tree app.
-- Single community, many families. Run with the Supabase CLI (`supabase db push`)
-- or paste into the SQL editor of a fresh project.

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------
create type public.gender_t            as enum ('male', 'female', 'other');
create type public.member_status_t     as enum ('pending', 'approved', 'rejected', 'blocked');
create type public.relation_t          as enum ('parent', 'spouse');
create type public.plan_t              as enum ('free', 'premium');
create type public.media_kind_t        as enum ('photo', 'video', 'document');
create type public.event_kind_t        as enum ('birth', 'education', 'marriage', 'migration', 'career', 'death', 'other');
create type public.suggestion_status_t as enum ('pending', 'accepted', 'dismissed');
create type public.ticket_status_t     as enum ('open', 'in_progress', 'resolved');
create type public.ticket_priority_t   as enum ('normal', 'high');

-- ---------------------------------------------------------------------------
-- Validators
-- ---------------------------------------------------------------------------
-- phones: [{"number": "+919876543210", "label": "mobile", "whatsapp": true}, ...]
-- Numbers are E.164 so members abroad work and wa.me links can be built.
create function public.valid_phones(v jsonb) returns boolean
language sql immutable as $$
  select jsonb_typeof(v) = 'array' and not exists (
    select 1 from jsonb_array_elements(v) e
    where jsonb_typeof(e) <> 'object'
       or coalesce(e ->> 'number', '') !~ '^\+[1-9][0-9]{6,14}$'
       or (e ? 'label' and jsonb_typeof(e -> 'label') <> 'string')
       or (e ? 'whatsapp' and jsonb_typeof(e -> 'whatsapp') <> 'boolean'));
$$;

-- ---------------------------------------------------------------------------
-- Tables
-- ---------------------------------------------------------------------------
create table public.profiles (
  id            uuid primary key references auth.users (id) on delete cascade,
  full_name     text,
  email         text,
  avatar_url    text,
  status        public.member_status_t not null default 'pending',
  is_admin      boolean not null default false,
  is_support    boolean not null default false,
  plan          public.plan_t not null default 'free',
  locale        text not null default 'en' check (locale in ('en', 'gu', 'hi')),
  successor_id  uuid references public.profiles (id) on delete set null,
  approved_by   uuid references public.profiles (id) on delete set null,
  approved_at   timestamptz,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  check (successor_id is distinct from id)
);
comment on column public.profiles.successor_id is
  'Legacy contact: gets edit rights over this user''s person record after the person is marked deceased.';

create table public.gotras (
  id        uuid primary key default gen_random_uuid(),
  name      text not null unique,
  kuldevi   text,
  kuldevta  text,
  notes     text,
  verified  boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.surname_gotras (
  id        uuid primary key default gen_random_uuid(),
  surname   text not null,
  village   text,
  gotra_id  uuid not null references public.gotras (id) on delete cascade,
  verified  boolean not null default false,
  created_by uuid default auth.uid() references public.profiles (id) on delete set null,
  created_at timestamptz not null default now()
);
create unique index surname_gotras_uniq on public.surname_gotras (lower(surname), coalesce(lower(village), ''), gotra_id);

create table public.families (
  id             uuid primary key default gen_random_uuid(),
  name           text not null,
  surname        text not null,
  native_village text,
  gotra_id       uuid references public.gotras (id) on delete set null,
  kuldevi        text,   -- family-level override of the gotra default
  kuldevta       text,
  description    text,
  cover_path     text,
  created_by     uuid default auth.uid() references public.profiles (id) on delete set null,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);

create table public.persons (
  id                  uuid primary key default gen_random_uuid(),
  family_id           uuid not null references public.families (id) on delete restrict,
  first_name          text not null check (length(first_name) between 1 and 80),
  middle_name         text,
  last_name           text not null check (length(last_name) between 1 and 80),
  maiden_name         text,
  nickname            text,
  gender              public.gender_t not null,
  dob                 date,
  dob_is_approx       boolean not null default false,
  dod                 date,
  is_alive            boolean not null default true,
  birth_place         text,
  birth_lat           double precision check (birth_lat between -90 and 90),
  birth_lng           double precision check (birth_lng between -180 and 180),
  current_place       text,
  current_lat         double precision check (current_lat between -90 and 90),
  current_lng         double precision check (current_lng between -180 and 180),
  native_village      text,
  gotra_id            uuid references public.gotras (id) on delete set null,
  kuldevi             text,   -- person-level override; falls back to family, then gotra
  kuldevta            text,
  phones              jsonb not null default '[]' check (public.valid_phones(phones)),
  email               text,
  occupation          text,
  education           text,
  marital_status      text,
  blood_group         text,
  biography           text,
  notes               text,
  passport_photo_path text,
  claimed_by          uuid unique references public.profiles (id) on delete set null,
  created_by          uuid default auth.uid() references public.profiles (id) on delete set null,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  search tsvector generated always as (
    to_tsvector('simple',
      coalesce(first_name, '') || ' ' || coalesce(middle_name, '') || ' ' ||
      coalesce(last_name, '') || ' ' || coalesce(maiden_name, '') || ' ' ||
      coalesce(nickname, '') || ' ' || coalesce(native_village, '') || ' ' ||
      coalesce(birth_place, '') || ' ' || coalesce(current_place, ''))
  ) stored,
  check (dod is null or dob is null or dod >= dob)
);
create index persons_family_idx on public.persons (family_id);
create index persons_search_idx on public.persons using gin (search);
create index persons_name_idx   on public.persons (lower(first_name), lower(last_name));

create table public.relationships (
  id         uuid primary key default gen_random_uuid(),
  kind       public.relation_t not null,
  -- parent: person_id is the parent, related_id the child.
  -- spouse: person_id < related_id (canonical order enforced by trigger).
  person_id  uuid not null references public.persons (id) on delete cascade,
  related_id uuid not null references public.persons (id) on delete cascade,
  married_on date,
  ended_on   date,
  created_by uuid default auth.uid() references public.profiles (id) on delete set null,
  created_at timestamptz not null default now(),
  check (person_id <> related_id),
  unique (kind, person_id, related_id)
);
create index relationships_related_idx on public.relationships (related_id);

create table public.life_events (
  id             uuid primary key default gen_random_uuid(),
  person_id      uuid not null references public.persons (id) on delete cascade,
  kind           public.event_kind_t not null default 'other',
  title          text not null check (length(title) between 1 and 200),
  description    text,
  event_date     date,
  date_is_approx boolean not null default false,
  place          text,
  lat            double precision check (lat between -90 and 90),
  lng            double precision check (lng between -180 and 180),
  created_by     uuid default auth.uid() references public.profiles (id) on delete set null,
  created_at     timestamptz not null default now()
);
create index life_events_person_idx on public.life_events (person_id, event_date);

create table public.albums (
  id          uuid primary key default gen_random_uuid(),
  title       text not null check (length(title) between 1 and 120),
  description text,
  family_id   uuid references public.families (id) on delete cascade,
  person_id   uuid references public.persons (id) on delete cascade,
  created_by  uuid default auth.uid() references public.profiles (id) on delete set null,
  created_at  timestamptz not null default now()
);

create table public.media (
  id           uuid primary key default gen_random_uuid(),
  kind         public.media_kind_t not null,
  album_id     uuid references public.albums (id) on delete cascade,
  person_id    uuid references public.persons (id) on delete cascade,
  storage_path text unique,
  external_url text,   -- videos are linked (YouTube/Drive), not uploaded: keeps the free 1 GB bucket for photos
  mime_type    text,
  size_bytes   integer check (size_bytes >= 0),
  width        integer,
  height       integer,
  caption      text,
  taken_on     date,
  uploaded_by  uuid default auth.uid() references public.profiles (id) on delete set null,
  created_at   timestamptz not null default now(),
  check (album_id is not null or person_id is not null),
  check ((storage_path is not null)::int + (external_url is not null)::int = 1),
  check (kind <> 'video' or external_url is not null)
);
create index media_album_idx  on public.media (album_id);
create index media_person_idx on public.media (person_id);

create table public.match_suggestions (
  id           uuid primary key default gen_random_uuid(),
  person_id    uuid not null references public.persons (id) on delete cascade,
  candidate_id uuid not null references public.persons (id) on delete cascade,
  score        integer not null check (score between 0 and 100),
  reasons      text[] not null default '{}',
  status       public.suggestion_status_t not null default 'pending',
  decided_by   uuid references public.profiles (id) on delete set null,
  decided_at   timestamptz,
  created_at   timestamptz not null default now(),
  check (person_id < candidate_id),
  unique (person_id, candidate_id)
);

create table public.notifications (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references public.profiles (id) on delete cascade,
  kind       text not null,
  title      text not null,
  body       text,
  data       jsonb not null default '{}',
  read_at    timestamptz,
  created_at timestamptz not null default now()
);
create index notifications_user_idx on public.notifications (user_id, created_at desc);

create table public.conversations (
  id         uuid primary key default gen_random_uuid(),
  created_by uuid default auth.uid() references public.profiles (id) on delete set null,
  created_at timestamptz not null default now()
);

create table public.conversation_participants (
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  user_id         uuid not null references public.profiles (id) on delete cascade,
  last_read_at    timestamptz,
  primary key (conversation_id, user_id)
);

create table public.messages (
  id              uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  sender_id       uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  body            text not null check (length(body) between 1 and 4000),
  created_at      timestamptz not null default now()
);
create index messages_conv_idx on public.messages (conversation_id, created_at);

create table public.support_tickets (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  subject     text not null check (length(subject) between 1 and 200),
  body        text not null,
  priority    public.ticket_priority_t not null default 'normal',
  status      public.ticket_status_t not null default 'open',
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create table public.support_messages (
  id         uuid primary key default gen_random_uuid(),
  ticket_id  uuid not null references public.support_tickets (id) on delete cascade,
  sender_id  uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  body       text not null check (length(body) between 1 and 4000),
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Helper functions (used by RLS)
-- ---------------------------------------------------------------------------
create function public.is_approved() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from profiles where id = auth.uid() and status = 'approved');
$$;

create function public.is_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from profiles where id = auth.uid() and status = 'approved' and is_admin);
$$;

create function public.is_support() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from profiles where id = auth.uid() and status = 'approved' and (is_support or is_admin));
$$;

-- Admins get every plan feature.
create function public.has_plan(required public.plan_t) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from profiles
    where id = auth.uid() and status = 'approved'
      and (is_admin or required = 'free' or plan = required));
$$;

-- Editing rights over a person: creator, the user who claimed it, admins, or the
-- successor of the claimant once the person is deceased.
create function public.can_edit_person(p uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from persons pe
    left join profiles owner on owner.id = pe.claimed_by
    where pe.id = p and (
      pe.created_by = auth.uid()
      or pe.claimed_by = auth.uid()
      or public.is_admin()
      or (not pe.is_alive and owner.successor_id = auth.uid())));
$$;

create function public.is_participant(c uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from conversation_participants where conversation_id = c and user_id = auth.uid());
$$;

-- ---------------------------------------------------------------------------
-- Generic triggers
-- ---------------------------------------------------------------------------
create function public.set_updated_at() returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;

create trigger profiles_updated_at before update on public.profiles for each row execute function public.set_updated_at();
create trigger families_updated_at before update on public.families for each row execute function public.set_updated_at();
create trigger persons_updated_at  before update on public.persons  for each row execute function public.set_updated_at();
create trigger tickets_updated_at  before update on public.support_tickets for each row execute function public.set_updated_at();

-- New auth user -> profile. The very first user becomes an approved admin so
-- somebody can approve everyone else.
create function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
declare bootstrap boolean;
begin
  select not exists (select 1 from profiles where is_admin) into bootstrap;
  insert into profiles (id, full_name, email, avatar_url, status, is_admin, approved_at)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', new.raw_user_meta_data ->> 'name'),
    new.email,
    coalesce(new.raw_user_meta_data ->> 'avatar_url', new.raw_user_meta_data ->> 'picture'),
    case when bootstrap then 'approved'::member_status_t else 'pending' end,
    bootstrap,
    case when bootstrap then now() end);
  return new;
end $$;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();

-- Non-admins may only edit their own display fields.
create function public.guard_profile_update() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if public.is_admin() then return new; end if;
  if new.status is distinct from old.status
     or new.is_admin is distinct from old.is_admin
     or new.is_support is distinct from old.is_support
     or new.plan is distinct from old.plan
     or new.approved_by is distinct from old.approved_by
     or new.approved_at is distinct from old.approved_at then
    raise exception 'only admins can change status, roles or plan';
  end if;
  return new;
end $$;
create trigger profiles_guard before update on public.profiles for each row execute function public.guard_profile_update();

create function public.guard_verified() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if not public.is_admin() then
    new.verified := false;   -- member edits always need a fresh admin look
  end if;
  return new;
end $$;
create trigger gotras_verified before insert or update on public.gotras for each row execute function public.guard_verified();
create trigger surname_gotras_verified before insert or update on public.surname_gotras for each row execute function public.guard_verified();

create function public.notify_users(user_ids uuid[], kind text, title text, body text, data jsonb default '{}')
returns void language sql security definer set search_path = public as $$
  insert into notifications (user_id, kind, title, body, data)
  select distinct u, kind, title, body, data from unnest(user_ids) as u where u is not null;
$$;

create function public.on_profile_status_change() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if new.status = 'approved' and old.status <> 'approved' then
    perform public.notify_users(array[new.id], 'membership', 'Welcome to the Samaj',
      'Your membership has been approved. You can now build your family tree.', '{}');
  end if;
  return new;
end $$;
create trigger profiles_status_notify after update of status on public.profiles
  for each row execute function public.on_profile_status_change();

-- ---------------------------------------------------------------------------
-- Family-tree integrity
-- ---------------------------------------------------------------------------
-- True when `ancestor` is an ancestor of `person`.
create function public.is_ancestor(ancestor uuid, person uuid) returns boolean
language sql stable security definer set search_path = public as $$
  with recursive up as (
    select person_id as id, 1 as depth from relationships where kind = 'parent' and related_id = person
    union
    select r.person_id, up.depth + 1 from relationships r join up on r.related_id = up.id
    where r.kind = 'parent' and up.depth < 60)
  select exists (select 1 from up where id = ancestor);
$$;

create function public.guard_relationship() returns trigger
language plpgsql security definer set search_path = public as $$
declare tmp uuid;
begin
  if new.kind = 'spouse' and new.person_id > new.related_id then
    tmp := new.person_id; new.person_id := new.related_id; new.related_id := tmp;
  end if;
  if new.kind = 'parent' then
    if public.is_ancestor(new.related_id, new.person_id) then
      raise exception 'cycle: % is already an ancestor of %', new.related_id, new.person_id;
    end if;
    -- mytail: hard cap of 2 parents; step-parents go in life_events/notes for now.
    if (select count(*) from relationships where kind = 'parent' and related_id = new.related_id) >= 2 then
      raise exception 'a person can have at most two parents';
    end if;
  end if;
  return new;
end $$;
create trigger relationships_guard before insert or update on public.relationships
  for each row execute function public.guard_relationship();

-- Children inherit the father's gotra when none is set.
create function public.inherit_gotra() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if new.kind = 'parent' then
    update persons c set gotra_id = p.gotra_id
    from persons p
    where c.id = new.related_id and p.id = new.person_id
      and c.gotra_id is null and p.gender = 'male' and p.gotra_id is not null;
  end if;
  return new;
end $$;
create trigger relationships_inherit_gotra after insert on public.relationships
  for each row execute function public.inherit_gotra();

-- ---------------------------------------------------------------------------
-- Tree queries
-- ---------------------------------------------------------------------------
-- Everyone connected to `root` within `max_hops` undirected relationship hops,
-- plus every relationship among them. Feeds the graph views.
create function public.get_tree(root uuid, max_hops integer default 4) returns jsonb
language sql stable security definer set search_path = public as $$
  with recursive walk as (
    select root as id, 0 as hops
    union
    select case when r.person_id = w.id then r.related_id else r.person_id end, w.hops + 1
    from walk w join relationships r on r.person_id = w.id or r.related_id = w.id
    where w.hops < max_hops
  ), ids as (select distinct id from walk)
  select jsonb_build_object(
    'persons', coalesce((select jsonb_agg(to_jsonb(p) - 'search') from persons p where p.id in (select id from ids)), '[]'),
    'relationships', coalesce((select jsonb_agg(to_jsonb(r)) from relationships r
        where r.person_id in (select id from ids) and r.related_id in (select id from ids)), '[]'))
  where public.is_approved();
$$;

create function public.get_ancestors(root uuid, max_depth integer default 12)
returns table (person_id uuid, depth integer, via uuid)
language sql stable security definer set search_path = public as $$
  with recursive up as (
    select r.person_id, 1 as depth, r.related_id as via
    from relationships r where r.kind = 'parent' and r.related_id = root
    union
    select r.person_id, up.depth + 1, r.related_id
    from relationships r join up on r.related_id = up.person_id
    where r.kind = 'parent' and up.depth < max_depth)
  select * from up where public.is_approved();
$$;

create function public.get_descendants(root uuid, max_depth integer default 12)
returns table (person_id uuid, depth integer, via uuid)
language sql stable security definer set search_path = public as $$
  with recursive down as (
    select r.related_id as person_id, 1 as depth, r.person_id as via
    from relationships r where r.kind = 'parent' and r.person_id = root
    union
    select r.related_id, down.depth + 1, r.person_id
    from relationships r join down on r.person_id = down.person_id
    where r.kind = 'parent' and down.depth < max_depth)
  select * from down where public.is_approved();
$$;

-- Prefix full-text search over names and places.
create function public.search_persons(q text, lim integer default 30)
returns setof public.persons
language sql stable security definer set search_path = public as $$
  select p.* from persons p
  where public.is_approved() and length(trim(q)) > 0
    and p.search @@ to_tsquery('simple',
      (select string_agg(quote_literal(w) || ':*', ' & ')
       from regexp_split_to_table(lower(trim(q)), '\s+') w where w <> ''))
  order by p.last_name, p.first_name
  limit greatest(1, least(lim, 200));
$$;

-- ---------------------------------------------------------------------------
-- Matches: likely duplicates of the same real person across families.
-- mytail: exact/prefix name compare + dob + village scoring, fine for one samaj
-- (thousands of people). Swap in pg_trgm similarity() if false negatives pile up.
-- ---------------------------------------------------------------------------
create function public.find_matches(p uuid)
returns table (candidate_id uuid, score integer, reasons text[])
language sql stable security definer set search_path = public as $$
  with me as (select * from persons where id = p),
  scored as (
    select c.id,
      (case when lower(c.first_name) = lower(me.first_name) then 40
            when left(lower(c.first_name), 4) = left(lower(me.first_name), 4) then 20 else 0 end)
      + (case when lower(c.last_name) = lower(me.last_name)
                or lower(coalesce(c.maiden_name, '')) = lower(me.last_name)
                or lower(coalesce(me.maiden_name, '')) = lower(c.last_name) then 20 else 0 end)
      + (case when c.dob is not null and me.dob is not null then
              case when c.dob = me.dob then 30
                   when abs(extract(year from c.dob) - extract(year from me.dob)) <= 1 then 15 else 0 end
         else 0 end)
      + (case when lower(coalesce(c.native_village, '')) = lower(coalesce(me.native_village, '-')) then 10 else 0 end)
      as score,
      array_remove(array[
        case when lower(c.first_name) = lower(me.first_name) then 'same first name' end,
        case when lower(c.last_name) = lower(me.last_name) then 'same surname' end,
        case when c.dob is not null and c.dob = me.dob then 'same date of birth' end,
        case when lower(coalesce(c.native_village, '')) = lower(coalesce(me.native_village, '-')) then 'same native village' end
      ], null) as reasons
    from persons c, me
    where c.id <> me.id and c.gender = me.gender and c.family_id <> me.family_id)
  select id, least(score, 100), reasons from scored
  where public.is_approved() and score >= 50
  order by score desc limit 20;
$$;

create function public.refresh_matches(p uuid) returns integer
language plpgsql security definer set search_path = public as $$
declare n integer;
begin
  if not public.is_approved() then raise exception 'not approved'; end if;
  insert into match_suggestions (person_id, candidate_id, score, reasons)
  select least(p, m.candidate_id), greatest(p, m.candidate_id), m.score, m.reasons
  from public.find_matches(p) m
  on conflict (person_id, candidate_id) do update
    set score = excluded.score, reasons = excluded.reasons
    where match_suggestions.status = 'pending';
  get diagnostics n = row_count;
  return n;
end $$;

-- Admin-only: fold `drop_id` into `keep_id`, rewiring everything that points at it.
create function public.merge_persons(keep_id uuid, drop_id uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not public.is_admin() then raise exception 'admin only'; end if;
  if keep_id = drop_id then raise exception 'cannot merge a person into itself'; end if;

  update persons k set
    middle_name = coalesce(k.middle_name, d.middle_name),
    maiden_name = coalesce(k.maiden_name, d.maiden_name),
    nickname = coalesce(k.nickname, d.nickname),
    dob = coalesce(k.dob, d.dob), dod = coalesce(k.dod, d.dod),
    birth_place = coalesce(k.birth_place, d.birth_place),
    birth_lat = coalesce(k.birth_lat, d.birth_lat), birth_lng = coalesce(k.birth_lng, d.birth_lng),
    current_place = coalesce(k.current_place, d.current_place),
    current_lat = coalesce(k.current_lat, d.current_lat), current_lng = coalesce(k.current_lng, d.current_lng),
    native_village = coalesce(k.native_village, d.native_village),
    gotra_id = coalesce(k.gotra_id, d.gotra_id),
    kuldevi = coalesce(k.kuldevi, d.kuldevi), kuldevta = coalesce(k.kuldevta, d.kuldevta),
    phones = (select coalesce(jsonb_agg(distinct x), '[]') from jsonb_array_elements(k.phones || d.phones) x),
    email = coalesce(k.email, d.email),
    occupation = coalesce(k.occupation, d.occupation), education = coalesce(k.education, d.education),
    biography = coalesce(k.biography, d.biography), notes = coalesce(k.notes, d.notes),
    passport_photo_path = coalesce(k.passport_photo_path, d.passport_photo_path),
    claimed_by = coalesce(k.claimed_by, d.claimed_by)
  from persons d where k.id = keep_id and d.id = drop_id;

  update persons set claimed_by = null where id = drop_id;

  -- Move edges, skipping ones that would duplicate or self-loop.
  update relationships r set person_id = keep_id
  where r.person_id = drop_id and r.related_id <> keep_id
    and not exists (select 1 from relationships x where x.kind = r.kind and x.person_id = keep_id and x.related_id = r.related_id);
  update relationships r set related_id = keep_id
  where r.related_id = drop_id and r.person_id <> keep_id
    and not exists (select 1 from relationships x where x.kind = r.kind and x.person_id = r.person_id and x.related_id = keep_id);
  delete from relationships where person_id = drop_id or related_id = drop_id;

  update life_events set person_id = keep_id where person_id = drop_id;
  update media set person_id = keep_id where person_id = drop_id;
  update albums set person_id = keep_id where person_id = drop_id;
  delete from match_suggestions where person_id = drop_id or candidate_id = drop_id;
  delete from persons where id = drop_id;
end $$;

-- ---------------------------------------------------------------------------
-- Migration map data: one row per hop a person made (birth -> migrations -> now).
-- ---------------------------------------------------------------------------
create function public.migration_paths(family uuid default null)
returns table (person_id uuid, full_name text, seq integer, place text, lat double precision, lng double precision, on_date date)
language sql stable security definer set search_path = public as $$
  with hops as (
    select p.id, p.first_name || ' ' || p.last_name as full_name, 0 as seq, p.birth_place, p.birth_lat, p.birth_lng, p.dob as on_date
    from persons p where p.birth_lat is not null and (family is null or p.family_id = family)
    union all
    select e.person_id, p.first_name || ' ' || p.last_name, 1, e.place, e.lat, e.lng, e.event_date
    from life_events e join persons p on p.id = e.person_id
    where e.kind = 'migration' and e.lat is not null and (family is null or p.family_id = family)
    union all
    select p.id, p.first_name || ' ' || p.last_name, 2, p.current_place, p.current_lat, p.current_lng, null
    from persons p where p.current_lat is not null and (family is null or p.family_id = family))
  select id, full_name,
         (row_number() over (partition by id order by seq, on_date nulls last))::integer,
         birth_place, birth_lat, birth_lng, on_date
  from hops where public.is_approved()
  order by id, seq, on_date nulls last;
$$;

-- ---------------------------------------------------------------------------
-- Digital account: export everything about me and my tree as JSON.
-- ---------------------------------------------------------------------------
create function public.export_my_data() returns jsonb
language plpgsql stable security definer set search_path = public as $$
declare me persons; tree jsonb; ids uuid[];
begin
  if not public.is_approved() then raise exception 'not approved'; end if;
  select * into me from persons where claimed_by = auth.uid();
  if me.id is null then
    return jsonb_build_object('profile', (select to_jsonb(p) from profiles p where id = auth.uid()), 'person', null);
  end if;
  tree := public.get_tree(me.id, 8);
  select array_agg((x ->> 'id')::uuid) into ids from jsonb_array_elements(tree -> 'persons') x;
  return jsonb_build_object(
    'exported_at', now(),
    'profile', (select to_jsonb(p) from profiles p where id = auth.uid()),
    'person', to_jsonb(me) - 'search',
    'family', (select to_jsonb(f) from families f where f.id = me.family_id),
    'tree', tree,
    'events', coalesce((select jsonb_agg(to_jsonb(e)) from life_events e where e.person_id = any(ids)), '[]'),
    'media', coalesce((select jsonb_agg(to_jsonb(m)) from media m where m.person_id = any(ids)), '[]'),
    'albums', coalesce((select jsonb_agg(to_jsonb(a)) from albums a where a.person_id = any(ids) or a.created_by = auth.uid()), '[]'));
end $$;

-- ---------------------------------------------------------------------------
-- Plan limits and notifications
-- ---------------------------------------------------------------------------
create function public.guard_album_insert() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if not public.has_plan('premium')
     and (select count(*) from albums where created_by = auth.uid()) >= 1 then
    raise exception 'free plan allows one album; upgrade for more';
  end if;
  return new;
end $$;
create trigger albums_plan_limit before insert on public.albums for each row execute function public.guard_album_insert();

create function public.set_ticket_priority() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  new.priority := case when exists (select 1 from profiles where id = new.user_id and (plan = 'premium' or is_admin))
                       then 'high'::ticket_priority_t else 'normal' end;
  return new;
end $$;
create trigger tickets_priority before insert on public.support_tickets for each row execute function public.set_ticket_priority();

create function public.on_ticket_change() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if new.status is distinct from old.status then
    perform public.notify_users(array[new.user_id], 'support', 'Support ticket ' || new.status::text,
      new.subject, jsonb_build_object('ticket_id', new.id));
  end if;
  return new;
end $$;
create trigger tickets_notify after update of status on public.support_tickets for each row execute function public.on_ticket_change();

create function public.on_support_message() returns trigger
language plpgsql security definer set search_path = public as $$
declare owner uuid;
begin
  select user_id into owner from support_tickets where id = new.ticket_id;
  if owner <> new.sender_id then
    perform public.notify_users(array[owner], 'support', 'Reply on your support ticket',
      left(new.body, 120), jsonb_build_object('ticket_id', new.ticket_id));
  end if;
  return new;
end $$;
create trigger support_messages_notify after insert on public.support_messages for each row execute function public.on_support_message();

-- Births, marriages and deaths go out to the whole samaj (the "news feed").
-- mytail: fan-out row per approved member on write; fine to ~10k members. Past
-- that, store one feed row and join on read.
create function public.on_life_event() returns trigger
language plpgsql security definer set search_path = public as $$
declare who text; ids uuid[];
begin
  if new.kind in ('birth', 'marriage', 'death') then
    select first_name || ' ' || last_name into who from persons where id = new.person_id;
    select array_agg(id) into ids from profiles where status = 'approved' and id is distinct from auth.uid();
    perform public.notify_users(ids, 'event', initcap(new.kind::text) || ': ' || who,
      coalesce(new.title, ''), jsonb_build_object('person_id', new.person_id, 'event_id', new.id));
  end if;
  return new;
end $$;
create trigger life_events_notify after insert on public.life_events for each row execute function public.on_life_event();

create function public.on_match_suggestion() returns trigger
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
create trigger match_suggestions_notify after insert on public.match_suggestions for each row execute function public.on_match_suggestion();

create function public.on_message() returns trigger
language plpgsql security definer set search_path = public as $$
declare ids uuid[]; who text;
begin
  select full_name into who from profiles where id = new.sender_id;
  select array_agg(user_id) into ids from conversation_participants
  where conversation_id = new.conversation_id and user_id <> new.sender_id;
  perform public.notify_users(ids, 'chat', coalesce(who, 'New message'), left(new.body, 120),
    jsonb_build_object('conversation_id', new.conversation_id));
  return new;
end $$;
create trigger messages_notify after insert on public.messages for each row execute function public.on_message();

-- "This is me": link an unclaimed person record to the signed-in user.
-- mytail: direct claim with a heads-up to the record's creator; add an approval
-- step if impersonation ever becomes a problem.
create function public.claim_person(p uuid) returns void
language plpgsql security definer set search_path = public as $$
declare creator uuid; who text;
begin
  if not public.is_approved() then raise exception 'not approved'; end if;
  if exists (select 1 from persons where claimed_by = auth.uid()) then
    raise exception 'you have already claimed a person record';
  end if;
  select created_by, first_name || ' ' || last_name into creator, who from persons where id = p and claimed_by is null;
  if who is null then raise exception 'person not found or already claimed'; end if;
  update persons set claimed_by = auth.uid() where id = p;
  if creator is distinct from auth.uid() then
    perform public.notify_users(array[creator], 'claim', 'Profile claimed',
      (select full_name from profiles where id = auth.uid()) || ' claimed the record for ' || who || '.',
      jsonb_build_object('person_id', p));
  end if;
end $$;

-- 1:1 chat lookup/creation.
create function public.get_or_create_direct_conversation(other uuid) returns uuid
language plpgsql security definer set search_path = public as $$
declare cid uuid;
begin
  if not public.has_plan('premium') then raise exception 'chat requires the premium plan'; end if;
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

-- ---------------------------------------------------------------------------
-- Row level security
-- ---------------------------------------------------------------------------
alter table public.profiles                  enable row level security;
alter table public.gotras                    enable row level security;
alter table public.surname_gotras            enable row level security;
alter table public.families                  enable row level security;
alter table public.persons                   enable row level security;
alter table public.relationships             enable row level security;
alter table public.life_events               enable row level security;
alter table public.albums                    enable row level security;
alter table public.media                     enable row level security;
alter table public.match_suggestions         enable row level security;
alter table public.notifications             enable row level security;
alter table public.conversations             enable row level security;
alter table public.conversation_participants enable row level security;
alter table public.messages                  enable row level security;
alter table public.support_tickets           enable row level security;
alter table public.support_messages          enable row level security;

create policy profiles_select on public.profiles for select to authenticated using (id = auth.uid() or public.is_approved());
create policy profiles_update on public.profiles for update to authenticated using (id = auth.uid() or public.is_admin());

create policy gotras_select on public.gotras for select to authenticated using (true);
create policy gotras_insert on public.gotras for insert to authenticated with check (public.is_approved());
create policy gotras_update on public.gotras for update to authenticated using (public.is_approved());
create policy gotras_delete on public.gotras for delete to authenticated using (public.is_admin());
create policy surname_gotras_select on public.surname_gotras for select to authenticated using (true);
create policy surname_gotras_insert on public.surname_gotras for insert to authenticated with check (public.is_approved() and created_by = auth.uid());
create policy surname_gotras_update on public.surname_gotras for update to authenticated using (public.is_approved());
create policy surname_gotras_delete on public.surname_gotras for delete to authenticated using (public.is_admin() or created_by = auth.uid());

create policy families_select on public.families for select to authenticated using (public.is_approved());
create policy families_insert on public.families for insert to authenticated with check (public.is_approved() and created_by = auth.uid());
create policy families_update on public.families for update to authenticated using (public.is_admin() or created_by = auth.uid());
create policy families_delete on public.families for delete to authenticated using (public.is_admin());

create policy persons_select on public.persons for select to authenticated using (public.is_approved());
create policy persons_insert on public.persons for insert to authenticated with check (public.is_approved() and created_by = auth.uid());
create policy persons_update on public.persons for update to authenticated using (public.can_edit_person(id));
create policy persons_delete on public.persons for delete to authenticated using (public.is_admin());

create policy relationships_select on public.relationships for select to authenticated using (public.is_approved());
create policy relationships_insert on public.relationships for insert to authenticated
  with check (public.is_approved() and created_by = auth.uid()
              and (public.can_edit_person(person_id) or public.can_edit_person(related_id)));
create policy relationships_update on public.relationships for update to authenticated
  using (public.can_edit_person(person_id) or public.can_edit_person(related_id));
create policy relationships_delete on public.relationships for delete to authenticated
  using (public.is_admin() or created_by = auth.uid());

create policy life_events_select on public.life_events for select to authenticated using (public.is_approved());
create policy life_events_insert on public.life_events for insert to authenticated
  with check (public.can_edit_person(person_id) and created_by = auth.uid());
create policy life_events_update on public.life_events for update to authenticated using (public.can_edit_person(person_id));
create policy life_events_delete on public.life_events for delete to authenticated using (public.can_edit_person(person_id));

create policy albums_select on public.albums for select to authenticated using (public.is_approved());
create policy albums_insert on public.albums for insert to authenticated with check (public.is_approved() and created_by = auth.uid());
create policy albums_update on public.albums for update to authenticated using (created_by = auth.uid() or public.is_admin());
create policy albums_delete on public.albums for delete to authenticated using (created_by = auth.uid() or public.is_admin());

create policy media_select on public.media for select to authenticated using (public.is_approved());
create policy media_insert on public.media for insert to authenticated
  with check (public.is_approved() and uploaded_by = auth.uid()
              and (kind = 'photo' or public.has_plan('premium')));
create policy media_update on public.media for update to authenticated using (uploaded_by = auth.uid() or public.is_admin());
create policy media_delete on public.media for delete to authenticated using (uploaded_by = auth.uid() or public.is_admin());

create policy matches_select on public.match_suggestions for select to authenticated using (public.is_approved());
create policy matches_update on public.match_suggestions for update to authenticated
  using (public.is_admin() or public.can_edit_person(person_id) or public.can_edit_person(candidate_id));

create policy notifications_select on public.notifications for select to authenticated using (user_id = auth.uid());
create policy notifications_update on public.notifications for update to authenticated using (user_id = auth.uid());
create policy notifications_delete on public.notifications for delete to authenticated using (user_id = auth.uid());

create policy conversations_select on public.conversations for select to authenticated using (public.is_participant(id));
create policy participants_select on public.conversation_participants for select to authenticated using (public.is_participant(conversation_id));
create policy participants_update on public.conversation_participants for update to authenticated using (user_id = auth.uid());
create policy messages_select on public.messages for select to authenticated using (public.is_participant(conversation_id));
create policy messages_insert on public.messages for insert to authenticated
  with check (sender_id = auth.uid() and public.is_participant(conversation_id));  -- starting a chat needs premium; replying is free

create policy tickets_select on public.support_tickets for select to authenticated using (user_id = auth.uid() or public.is_support());
create policy tickets_insert on public.support_tickets for insert to authenticated with check (public.is_approved() and user_id = auth.uid());
create policy tickets_update on public.support_tickets for update to authenticated using (user_id = auth.uid() or public.is_support());
create policy support_messages_select on public.support_messages for select to authenticated
  using (exists (select 1 from public.support_tickets t where t.id = ticket_id and (t.user_id = auth.uid() or public.is_support())));
create policy support_messages_insert on public.support_messages for insert to authenticated
  with check (sender_id = auth.uid()
              and exists (select 1 from public.support_tickets t where t.id = ticket_id and (t.user_id = auth.uid() or public.is_support())));

-- ---------------------------------------------------------------------------
-- Storage: one private bucket (Supabase free tier: 1 GB). Paths: passport/<person>.jpg, albums/<album>/<file>, persons/<person>/<file>
-- ---------------------------------------------------------------------------
insert into storage.buckets (id, name, public, file_size_limit)
values ('media', 'media', false, 5242880)  -- 5 MB per file; free tier bucket is 1 GB
on conflict (id) do nothing;

create policy media_bucket_read on storage.objects for select to authenticated
  using (bucket_id = 'media' and public.is_approved());
create policy media_bucket_insert on storage.objects for insert to authenticated
  with check (bucket_id = 'media' and public.is_approved());
create policy media_bucket_update on storage.objects for update to authenticated
  using (bucket_id = 'media' and (owner = auth.uid() or public.is_admin()));
create policy media_bucket_delete on storage.objects for delete to authenticated
  using (bucket_id = 'media' and (owner = auth.uid() or public.is_admin()));

-- ---------------------------------------------------------------------------
-- Realtime
-- ---------------------------------------------------------------------------
alter publication supabase_realtime add table public.messages, public.notifications, public.profiles;

-- ---------------------------------------------------------------------------
-- Seed: reference gotra / kuldevi rows. Unverified on purpose; admins curate
-- them in-app and members can add surname -> gotra mappings for their village.
-- ---------------------------------------------------------------------------
insert into public.gotras (name, kuldevi, kuldevta, notes) values
  ('Ashapura',   'Ashapura Mata',   'Vishwakarma', 'Seed entry. Confirm with family elders.'),
  ('Khodiyar',   'Khodiyar Mata',   'Vishwakarma', 'Seed entry. Confirm with family elders.'),
  ('Chamunda',   'Chamunda Mata',   'Vishwakarma', 'Seed entry. Confirm with family elders.'),
  ('Ambaji',     'Amba Mata',       'Vishwakarma', 'Seed entry. Confirm with family elders.'),
  ('Bahuchar',   'Bahuchar Mata',   'Vishwakarma', 'Seed entry. Confirm with family elders.'),
  ('Momai',      'Momai Mata',      'Vishwakarma', 'Seed entry. Confirm with family elders.'),
  ('Randal',     'Randal Mata',     'Vishwakarma', 'Seed entry. Confirm with family elders.'),
  ('Meldi',      'Meldi Mata',      'Vishwakarma', 'Seed entry. Confirm with family elders.'),
  ('Harsiddhi',  'Harsiddhi Mata',  'Vishwakarma', 'Seed entry. Confirm with family elders.'),
  ('Kalika',     'Kalika Mata',     'Vishwakarma', 'Seed entry. Confirm with family elders.'),
  ('Butbhavani', 'Butbhavani Mata', 'Vishwakarma', 'Seed entry. Confirm with family elders.'),
  ('Sikotar',    'Sikotar Mata',    'Vishwakarma', 'Seed entry. Confirm with family elders.'),
  ('Vahanvati',  'Vahanvati Mata',  'Vishwakarma', 'Seed entry. Confirm with family elders.');
