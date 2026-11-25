#!/usr/bin/env bash
# Builds one plain Markdown "guide" per skill into guides/.
# Each guide holds the skill's steps plus every references/ and assets/ file,
# so Claude Duet can read a whole skill from one public link, with no upload.
set -euo pipefail
cd "$(dirname "$0")/.."
out="${1:-guides}"   # check.sh passes a temp folder to compare against
mkdir -p "$out"
for dir in skills/*/; do
  name=$(basename "$dir")
  f="$out/$name.md"
  {
    echo "# Job search kit guide: $name"
    echo
    echo "Part of the job-search-kit coaching guides. Everything this guide mentions in references/ or assets/ is included further down this page, under its file name."
    echo
    # Drop the YAML frontmatter (between the first two --- lines)
    awk 'NR==1 && /^---$/ {fm=1; next} fm && /^---$/ {fm=0; next} !fm' "$dir/SKILL.md"
    for part in "$dir"references/*.md "$dir"assets/*; do
      [ -f "$part" ] || continue
      echo
      echo "---"
      echo
      echo "## File: ${part#$dir}"
      echo
      cat "$part"
    done
  } > "$f"
  echo "built $f"
done
