-- Supabase grants these automatically; needed locally so `set role authenticated` works.
grant usage on schema public, storage, auth to anon, authenticated, service_role;
grant all on all tables in schema public to authenticated;
grant all on all sequences in schema public to authenticated;
grant execute on all functions in schema public to authenticated;
grant all on all tables in schema storage to authenticated;
grant execute on all functions in schema auth to authenticated;
