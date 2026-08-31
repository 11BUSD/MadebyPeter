#!/usr/bin/env bash
set -euo pipefail
TARGET="${1:-${TARGET_URL:-https://example.com}}"
export PREVIEW_HOLD_MS="${PREVIEW_HOLD_MS:-120000}"
rm -f artifacts/preview-url.txt
npm run start -- "$TARGET" &
PIPELINE_PID=$!
cleanup(){ kill "$PIPELINE_PID" 2>/dev/null || true; }
trap cleanup EXIT
for _ in $(seq 1 60); do [[ -s artifacts/preview-url.txt ]] && break; sleep 1; done
[[ -s artifacts/preview-url.txt ]] || { echo "preview URL was not produced" >&2; exit 1; }
python3 desktop/verify.py
wait "$PIPELINE_PID"
trap - EXIT
echo "Done. Open artifacts/report.html and artifacts/desktop-proof.png"
