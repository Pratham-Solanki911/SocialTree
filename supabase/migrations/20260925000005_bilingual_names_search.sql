-- Names in Gujarati and English, and search that finds people by either.

alter table public.persons
  add column first_name_en text, add column middle_name_en text,
  add column last_name_en text, add column maiden_name_en text;
alter table public.families add column name_en text, add column surname_en text;

-- Backfill the imported Solanki Parivar Ambo chart (ids a3b00000-…).
update public.persons set first_name_en = nullif(trim(nickname), ''), nickname = null
where id::text like 'a3b00000-%' and nickname is not null;

create temporary table surname_map (gu text, en text);
insert into surname_map values ('સોલંકી','Solanki'),('વાઘેલા','Vaghela'),('ગોહેલ','Gohel'),('મારુ','Maru'),('ટંકારીયા','Tankariya'),
  ('પીઠડીયા','Pithadiya'),('લીંબડ','Limbad'),('રાઠોડ','Rathod'),('પરમાર','Parmar'),('અંટાળા','Antala'),('ચૌહાણ','Chauhan'),('સાંગાણી','Sangani');
update public.persons p set last_name_en = m.en from surname_map m where p.id::text like 'a3b00000-%' and p.last_name = m.gu and p.last_name_en is null;
update public.persons p set maiden_name_en = m.en from surname_map m where p.id::text like 'a3b00000-%' and p.maiden_name = m.gu and p.maiden_name_en is null;
update public.persons p set middle_name_en = m.en from (values ('રાઘવ','Raghav'),('ધીરજલાલ','Dhirajlal'),('ભીખા','Bhikha'),('ગોરધન','Gordhan')) m(gu, en)
where p.id::text like 'a3b00000-%' and p.middle_name = m.gu and p.middle_name_en is null;
update public.families f set surname_en = m.en, name_en = m.en || ' family' from surname_map m
where f.id::text like 'a3b0f000-%' and f.surname = m.gu and f.surname_en is null;

-- Search. The full-text parser drops Gujarati letters, so search is a plain
-- substring match over a lowercased text of both scripts, ranked by where the
-- match starts. mytail: ilike over a few thousand rows is instant; add pg_trgm
-- + a GIN index if the samaj grows past ~50k people.
alter table public.persons drop column search;
drop index if exists public.persons_search_idx;
alter table public.persons add column search_text text generated always as (
  lower(coalesce(first_name, '') || ' ' || coalesce(middle_name, '') || ' ' || coalesce(last_name, '') || ' ' ||
        coalesce(maiden_name, '') || ' ' || coalesce(nickname, '') || ' ' || coalesce(first_name_en, '') || ' ' ||
        coalesce(middle_name_en, '') || ' ' || coalesce(last_name_en, '') || ' ' || coalesce(maiden_name_en, '') || ' ' ||
        coalesce(native_village, '') || ' ' || coalesce(birth_place, '') || ' ' || coalesce(current_place, ''))) stored;

drop function if exists public.search_persons(text, integer);
-- Every typed word must appear somewhere; results carry the father's name so
-- same-named people can be told apart.
create function public.search_persons(q text, lim integer default 30) returns jsonb
language sql stable security definer set search_path = public as $$
  with words as (select w from regexp_split_to_table(lower(trim(q)), '\s+') w where w <> ''),
  hits as (
    select p.*,
      least(position((select w from words limit 1) in lower(p.first_name)),
            position((select w from words limit 1) in lower(coalesce(p.first_name_en, '~')))) as pos
    from persons p
    where exists (select 1 from words) and not exists (select 1 from words where p.search_text not like '%' || w || '%'))
  select coalesce(jsonb_agg(row order by (case when pos = 1 then 0 when pos > 1 then 1 else 2 end), last_name, first_name), '[]')
  from (
    select (to_jsonb(h) - 'search_text') || jsonb_build_object(
      'father_name', f.first_name, 'father_name_en', f.first_name_en, 'father_gender', f.gender, 'family_name', fam.name, 'family_name_en', fam.name_en) as row,
      h.pos, h.last_name, h.first_name
    from hits h
    left join lateral (select par.first_name, par.first_name_en, par.gender from relationships r join persons par on par.id = r.person_id
                       where r.kind = 'parent' and r.related_id = h.id and par.gender = 'male' limit 1) f on true
    left join families fam on fam.id = h.family_id
    where public.is_approved()
    limit greatest(1, least(lim, 200))) x;
$$;

-- "Are you this person?" now matches either script, ignoring bhai/ben.
create or replace function public.find_myself(first_name text, last_name text, village text default null, birth_year integer default null, phone text default null)
returns table (person_id uuid, score integer, parents text)
language sql stable security definer set search_path = public as $$
  with me as (
    select regexp_replace(lower(trim(find_myself.first_name)), '(bhai|ben|bahen|ભાઈ|બેન|બહેન)$', '') fn,
           lower(trim(find_myself.last_name)) ln,
           lower(nullif(trim(find_myself.village), '')) vil, find_myself.birth_year yr,
           nullif(trim(find_myself.phone), '') ph,
           lower((select email from profiles where id = auth.uid())) em),
  cand as (
    select p.*,
      regexp_replace(lower(p.first_name), '(bhai|ben|bahen|ભાઈ|બેન|બહેન)$', '') as fn_gu,
      regexp_replace(lower(coalesce(p.first_name_en, '')), '(bhai|ben|bahen)$', '') as fn_en
    from persons p where p.is_alive and p.dod is null and p.claimed_by is null),
  scored as (
    select c.id,
      (case when me.fn <> '' and (c.fn_gu = me.fn or c.fn_en = me.fn) then 40
            when me.fn <> '' and (left(c.fn_gu, 3) = left(me.fn, 3) or left(c.fn_en, 4) = left(me.fn, 4)) then 20 else 0 end)
      + (case when me.ln <> '' and me.ln in (lower(c.last_name), lower(coalesce(c.last_name_en, '')), lower(coalesce(c.maiden_name, '')), lower(coalesce(c.maiden_name_en, ''))) then 20 else 0 end)
      + (case when me.yr is not null and c.dob is not null and abs(extract(year from c.dob) - me.yr) <= 1 then 25 else 0 end)
      + (case when me.vil is not null and lower(coalesce(c.native_village, '')) = me.vil then 15 else 0 end)
      + (case when me.ph is not null and c.phones::text like '%' || me.ph || '%' then 40 else 0 end)
      + (case when me.em is not null and lower(coalesce(c.email, '')) = me.em then 60 else 0 end) as score
    from cand c, me)
  select s.id, least(s.score, 100),
    (select string_agg(coalesce(par.first_name_en, par.first_name) || ' ' || coalesce(par.last_name_en, par.last_name), ', ')
     from relationships r join persons par on par.id = r.person_id where r.kind = 'parent' and r.related_id = s.id)
  from scored s where public.is_approved() and s.score >= 40
  order by s.score desc limit 15;
$$;

-- Lock down again (see 0004).
revoke execute on function public.search_persons(text, integer) from public, anon;
revoke execute on function public.find_myself(text, text, text, integer, text) from public, anon;
grant execute on function public.search_persons(text, integer) to authenticated;
grant execute on function public.find_myself(text, text, text, integer, text) to authenticated;

drop table surname_map;
