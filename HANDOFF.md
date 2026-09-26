# Agent handoff: finish SocialTree setup on the owner's machine

> **Update 2026-09-25 (handoff 2 done in the cloud session):** plans removed,
> PDF tree export added, logo + wordmark added, first-login language screen
> with salutations added, all records editable by every approved member.
> **Run `supabase/migrations/20260925000002_free_for_all_and_pdf_tree.sql` and then
> `20260925000003_identity_claims.sql` in the SQL editor, in that order, once each.**
> Identity claims ("this is me" flow, caretakers, admin confirmation for deaths)
> live in 0003. **Handoff 3 (bilingual names + search): run
> `20260925000005_bilingual_names_search.sql` once.** `0004_relock_functions.sql`
> is committed as recreated from its description; keep the applied local copy if it differs.
> **Gap fixes: run `20260925000006_gaps.sql` once** (localisable notifications,
> admin sign-up alerts, death event marks deceased, bilingual matching, bulk match
> check, large-text setting). If the local
> `20260925000001_function_grants.sql` differs from the committed one, keep the
> local (already applied) version. Wordmark spelling used: "Machhukathiya"
> (Gujarati: મચ્છુકાઠિયા); change `lib/core/branding.dart`, the two wordmark
> SVGs and `lib/features/tree/tree_pdf.dart` if the owner prefers "MacchuKathya".

You are running locally on the project owner's computer with their browser and
shell. The code is complete and pushed on branch `claude/fervent-wozniak-mfafkt`.
Your job is deployment setup only. Do not rewrite app code.

## Project facts

- Supabase project ref: `dcrggwdfanqmbyjanbaq`
- Supabase URL: `https://dcrggwdfanqmbyjanbaq.supabase.co`
- Publishable (anon) key: `sb_publishable_q5IYwBYNPa3rDlrHTg1cKA_-31R75OK` (public, safe in build flags)
- Database password: ask the owner. It was pasted into a chat earlier, so
  first tell them to **reset it** in Dashboard → Project Settings → Database.
- Deep link scheme for OAuth: `in.samaj.socialtree://login-callback`
  (already configured in AndroidManifest.xml and Info.plist).
- Dashboard: https://supabase.com/dashboard/project/dcrggwdfanqmbyjanbaq

## Steps (do in order, verify each)

### 1. Get the code
```bash
git clone https://github.com/Pratham-Solanki911/SocialTree.git
cd SocialTree
git checkout claude/fervent-wozniak-mfafkt
```

### 2. Apply the database migration
Preferred (CLI):
```bash
npm i -g supabase          # or brew install supabase/tap/supabase
supabase login             # opens browser
supabase link --project-ref dcrggwdfanqmbyjanbaq   # asks for DB password
supabase db push
```
Fallback (no CLI): open Dashboard → SQL Editor → New query, paste the whole
contents of `supabase/migrations/20260925000000_init.sql`, Run.

Verify: Dashboard → Table Editor shows `profiles`, `families`, `persons`,
`relationships`, `gotras` (13 seed rows), and Storage shows a private bucket
`media`.

### 3. Google OAuth
1. Google Cloud Console → APIs & Services → Credentials → Create OAuth client ID
   → type **Web application**.
   - Authorised redirect URI: `https://dcrggwdfanqmbyjanbaq.supabase.co/auth/v1/callback`
   - If asked, configure the consent screen first (External, app name
     "SocialTree", owner's email). Test mode is fine initially; add the
     owner's Gmail as a test user.
2. Supabase Dashboard → Authentication → Providers → Google → enable, paste
   Client ID and Client Secret, Save.
3. Dashboard → Authentication → URL Configuration:
   - Site URL: the web URL if hosting, else `http://localhost:3000`
   - Redirect URLs: add `in.samaj.socialtree://login-callback` and, for web
     dev, `http://localhost:3000/**`.

### 4. Run the app
Flutter stable must be installed (`flutter doctor`).
```bash
flutter pub get
flutter gen-l10n
# Web (fastest to verify):
flutter run -d chrome --web-port 3000 \
  --dart-define=SUPABASE_URL=https://dcrggwdfanqmbyjanbaq.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=sb_publishable_q5IYwBYNPa3rDlrHTg1cKA_-31R75OK
# Android device/emulator: same command with -d <device id>
```
Verify: Google sign-in completes, and the first signed-in user lands on Home
(that user is auto-approved as admin). Create a family, add a person with a
passport photo, confirm the photo appears (bucket upload + signed URL work).

### 5. Free-tier keep-alive
GitHub repo → Settings → Secrets and variables → Actions → add:
- `SUPABASE_URL` = `https://dcrggwdfanqmbyjanbaq.supabase.co`
- `SUPABASE_ANON_KEY` = the publishable key above
Then Actions → "Supabase keep-alive" → Run workflow once to confirm it passes.

### 6. Host the web app on GitHub Pages (this is the main distribution channel)
1. GitHub repo → Settings → Pages → Build and deployment → Source: **GitHub Actions**.
2. Secrets from step 5 must exist (`SUPABASE_URL`, `SUPABASE_ANON_KEY`).
3. Actions → "Deploy web" → Run workflow (it also runs on every push to
   `main` and to `claude/fervent-wozniak-mfafkt`).
4. The site URL is `https://<github-username>.github.io/SocialTree/`.
5. Supabase → Authentication → URL Configuration:
   - Site URL: `https://<github-username>.github.io/SocialTree/`
   - Redirect URLs: add `https://<github-username>.github.io/SocialTree/**`
Verify: open the site on a phone, sign in with Google, use "Add to Home
screen" (it is an installable PWA).

## Troubleshooting

- `relation ... already exists` on migration: it was partly applied. Run
  `supabase db reset --linked` (destroys data) or drop the `public` objects
  and re-run.
- OAuth "redirect_uri_mismatch": the Google client redirect URI must be
  exactly the `/auth/v1/callback` URL above.
- Mobile returns to app but stays on sign-in: the redirect URL in Supabase
  URL Configuration is missing `in.samaj.socialtree://login-callback`.
- Photos fail to load: bucket `media` must exist and be private; the
  migration creates it. Re-run the storage section of the migration if not.
- Everything else: `README.md` has the architecture and limits.
