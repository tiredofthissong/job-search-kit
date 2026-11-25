#!/usr/bin/env bash
# Builds upload-ready skill zips into dist/.
# 1. Copies shared/coach-rules.md into each skill's references/ folder.
# 2. Zips each skill folder so the folder itself sits at the top of the zip
#    (claude.ai requires the skill folder, not loose files, at the zip root).
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p dist
rm -f dist/*.zip
for dir in skills/*/; do
  name=$(basename "$dir")
  mkdir -p "$dir/references"
  cp shared/coach-rules.md "$dir/references/coach-rules.md"
  # -X drops extra file attributes so zips are the same on Mac and Linux
  (cd skills && zip -qrX "../dist/$name.zip" "$name" -x '*.DS_Store')
  echo "built dist/$name.zip"
done
