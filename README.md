# SocialTree

Family trees, member records and community roots for the **Shri Machhukathiya Sai Suthar Samaj**. One community, many families, one connected tree.

Flutter (Android, iOS, web) + Supabase (Postgres, Google sign-in, storage, realtime). Built to run entirely on Supabase's free tier.

## Features

- **Families and people**: every person belongs to a family; demographics, gotra, kuldevi/kuldevta (editable at gotra, family and person level), education, occupation, blood group, biography, notes.
- **Passport photo** compressed on-device to about 100 KB (JPEG, EXIF stripped) before upload.
- **Phone numbers** in international E.164 format with per-number WhatsApp flag: tap to open `wa.me` or dial. Members abroad are first-class.
- **Shared tree**: parent and spouse links across families, cycle and two-parent guards in the database, gotra inherited down the male line.
- **Multiple views**: layered graph, pedigree (ancestors) chart, descendants outline, plus a per-person timeline of life events.
- **Migration map**: birth place, migration events and current place drawn as paths over Indian government base maps (NIC Bharatmaps, ISRO Bhuvan) with OpenStreetMap as fallback. Locations are picked by tapping the map; no paid geocoding.
- **Search** across names, villages and places, with an "only my ancestors" filter.
- **Matches**: suggests likely duplicates of the same person across families; admins merge them.
- **Gotra & Kuldevi lookup** by surname and village. Members add and correct entries; admins mark them verified.
- **Albums and media**: photos (compressed), video links, PDF documents.
- **Samaj feed and notifications**: births, marriages and deaths go to everyone; personal notifications for chat, matches, support and approvals (in-app, realtime).
- **Chat**: 1:1 messaging between members.
- **Support tickets** with priority by plan.
- **Digital account**: legacy contact who can maintain your record after you pass away, and a full JSON export of your data and tree.
- **Plans** (free / premium) assigned by admins, no payments: premium unlocks unlimited albums, video links, documents, starting chats and high-priority support. Replying to chats is free for everyone.
- **Languages**: English, Gujarati, Hindi (per-user setting).
- **Admin**: approve members, roles, plans, block.

## Free-tier design

| Concern | Choice |
|---|---|
| Database | One Postgres schema, row-level security, no extra services |
| Auth | Google OAuth through the browser (no SMS cost, no Google SDK) |
| Storage (1 GB) | Passport ≤100 KB, album photos ≤300 KB, PDFs ≤5 MB, videos stored as links only |
| Realtime | Only `messages`, `notifications`, `profiles` |
| Push notifications | Not used; in-app notifications only |
| Maps | Public government tile services + OpenStreetMap, no API keys |
| Project pausing | `.github/workflows/supabase-keepalive.yml` pings the project every 3 days |

## Setup

### 1. Supabase project

1. Create a project at supabase.com (free plan).
2. Run `supabase/migrations/20260925000000_init.sql` in the SQL editor, or with the CLI: `supabase link` then `supabase db push`.
   The migration creates all tables, policies, functions, the private `media` bucket, realtime settings and seed gotra rows.
3. **Auth → Providers → Google**: enable it with a Google OAuth client (Web application type). Set the client's authorised redirect URI to `https://<project-ref>.supabase.co/auth/v1/callback`.
4. **Auth → URL configuration**: add these redirect URLs:
   - `in.samaj.socialtree://login-callback` (Android / iOS)
   - your web origin, for example `http://localhost:3000` and the deployed site URL.
5. The **first user to sign in becomes an approved admin** automatically. Everyone after that waits for approval on the Admin screen.

### 2. Run the app

```bash
flutter pub get
flutter gen-l10n
flutter run --dart-define=SUPABASE_URL=https://<project-ref>.supabase.co \
            --dart-define=SUPABASE_ANON_KEY=<anon or publishable key>
```

Optional: `--dart-define=AUTH_REDIRECT=<scheme>://login-callback` if you change the deep link. Update `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist` to match.

### 3. Build

```bash
flutter build apk --release --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
flutter build web --release --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

The web build can be hosted for free on GitHub Pages, Cloudflare Pages or Netlify.

### 4. Keep the free project awake

Add repository secrets `SUPABASE_URL` and `SUPABASE_ANON_KEY` so the keep-alive workflow can run.

## Tests

```bash
flutter analyze
flutter test                                  # tree logic, phones, models
PG_BIN=/usr/lib/postgresql/16/bin supabase/tests/run_local.sh   # schema smoke test on a throwaway Postgres
```

CI (`.github/workflows/flutter-ci.yml`) runs all three on every push.

## Maps

Default source is NIC Bharatmaps (Admin_Boundary_District tile cache). ISRO Bhuvan WMS and OpenStreetMap are selectable from the layers button. Government services can be slow or change layer names; if tiles fail the app offers to switch to OpenStreetMap. Verify layer names against each service's capabilities document if a source stops rendering.

## Project layout

```
supabase/migrations/   schema, RLS, functions, seed
supabase/tests/        local Postgres smoke test
lib/core/              env, Supabase providers, image compression, phones, shared widgets
lib/models/            row models + in-memory TreeData
lib/data/              Supabase queries (Repos) and Riverpod providers
lib/features/          one folder per screen group
lib/l10n/              app_en.arb, app_gu.arb, app_hi.arb (+ generated code)
```

## Known limits

- Notifications are in-app only. Add Firebase Cloud Messaging if push is needed.
- Videos are links (YouTube / Drive), not uploads.
- Match scoring is name + date + village based; swap in `pg_trgm` similarity for fuzzier matching.
- Spouse lines are not drawn in the graph view; spouses are listed on each card.
