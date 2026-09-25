-- EXECUTE-to-PUBLIC is a global default that `alter default privileges` does
-- not touch, so functions from 0002/0003 were callable by anon. Revoke for
-- every function in public and re-grant to authenticated; keep internal
-- helpers off limits. (Recreated from the copy applied on 2026-09-25; keep the
-- applied copy if it differs.)
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
revoke execute on function public.apply_claim(uuid, uuid) from authenticated;
revoke execute on function public.notify_claim_approvers(uuid, uuid, uuid) from authenticated;
