# Agent handoff: finish SocialTree setup on the owner's machine

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

### 6. Optional: host the web build
```bash
flutter build web --release \
  --dart-define=SUPABASE_URL=https://dcrggwdfanqmbyjanbaq.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=sb_publishable_q5IYwBYNPa3rDlrHTg1cKA_-31R75OK
```
Deploy `build/web` to GitHub Pages / Cloudflare Pages / Netlify, then add the
final URL to Supabase Redirect URLs and Site URL (step 3.3).

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
