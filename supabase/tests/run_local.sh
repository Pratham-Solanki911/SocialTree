#!/usr/bin/env bash
# Runs the migration and smoke test on a throwaway local PostgreSQL (15+).
# Usage: [PG_BIN=/path/to/pg/bin] supabase/tests/run_local.sh
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
PG_BIN=${PG_BIN:-$(pg_config --bindir)}
tmp=$(mktemp -d)
port=${PG_PORT:-54329}
run=""
if [ "$(id -u)" = 0 ]; then chown -R nobody "$tmp"; run="runuser -u nobody --"; fi
trap '$run "$PG_BIN/pg_ctl" -D "$tmp/data" stop -m immediate >/dev/null 2>&1 || true; rm -rf "$tmp"' EXIT
$run "$PG_BIN/initdb" -D "$tmp/data" -U postgres --auth=trust >/dev/null
$run "$PG_BIN/pg_ctl" -D "$tmp/data" -o "-p $port -k $tmp -c listen_addresses=''" -l "$tmp/pg.log" -w start >/dev/null
psql() { "$PG_BIN/psql" -v ON_ERROR_STOP=1 -q -h "$tmp" -p "$port" -U postgres -d postgres "$@"; }
psql -f "$here/stubs.sql"
for f in "$here"/../migrations/*.sql; do psql -f "$f"; done
psql -f "$here/grants.sql"
psql -f "$here/smoke.sql"
echo "smoke test passed"
