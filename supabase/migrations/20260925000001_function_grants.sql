-- Tighten function execution: nothing for anon/public, authenticated only,
-- and internal helpers not callable from clients at all.
-- (Recreated from the version applied on 2026-09-25; keep the applied copy if it differs.)
alter default privileges in schema public revoke execute on functions from public;
alter default privileges in schema public revoke execute on functions from anon;

do $$
declare f record;
begin
  for f in select p.oid::regprocedure as sig from pg_proc p join pg_namespace n on n.oid = p.pronamespace where n.nspname = 'public' loop
    execute format('revoke execute on function %s from public, anon', f.sig);
    execute format('grant execute on function %s to authenticated', f.sig);
  end loop;
end $$;

revoke execute on function public.notify_users(uuid[], text, text, text, jsonb) from authenticated;
revoke execute on function public.find_matches(uuid) from authenticated;
