#!/usr/bin/env bash
# Checks the kit before it ships. Exits non-zero on any problem.
set -uo pipefail
cd "$(dirname "$0")/.."
fail=0
err() { echo "FAIL: $*"; fail=1; }

# 1. Every skill: SKILL.md exists, name matches folder, description present and under 200 chars.
for dir in skills/*/; do
  name=$(basename "$dir")
  f="$dir/SKILL.md"
  [ -f "$f" ] || { err "$name has no SKILL.md"; continue; }
  fm_name=$(sed -n '2,6p' "$f" | grep -m1 '^name:' | sed 's/^name: *//')
  [ "$fm_name" = "$name" ] || err "$name: frontmatter name '$fm_name' does not match folder"
  echo "$name" | grep -Eq '^[a-z0-9-]{1,64}$' || err "$name: name must be lowercase letters, numbers, hyphens"
  desc=$(sed -n '2,6p' "$f" | grep -m1 '^description:' | sed 's/^description: *//')
  [ -n "$desc" ] || err "$name: missing description"
  len=${#desc}
  [ "$len" -le 200 ] || err "$name: description is $len chars (max 200)"
  lines=$(wc -l < "$f")
  [ "$lines" -le 500 ] || err "$name: SKILL.md is $lines lines (max 500)"
  # every references/ file named in SKILL.md must exist
  for ref in $(grep -oE '(references|assets)/[A-Za-z0-9._-]+' "$f" | sort -u); do
    [ -f "$dir/$ref" ] || err "$name: SKILL.md mentions $ref but it is missing"
  done
  cmp -s shared/coach-rules.md "$dir/references/coach-rules.md" || err "$name: references/coach-rules.md is out of date (run scripts/build-zips.sh)"
  [ -f "dist/$name.zip" ] || err "$name: dist/$name.zip missing (run scripts/build-zips.sh)"
  [ -f "guides/$name.md" ] || err "$name: guides/$name.md missing (run scripts/build-guides.sh)"
done

# 2. No secrets.
secrets='(ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{40,}|gh[ousr]_[A-Za-z0-9]{30,}|sk-ant-[A-Za-z0-9_-]{20,}|sk-[A-Za-z0-9]{32,}|AKIA[0-9A-Z]{16}|xox[baprs]-[A-Za-z0-9-]{10,}|-----BEGIN [A-Z ]*PRIVATE KEY-----)'
if grep -rnIE "$secrets" --exclude-dir=.git --exclude-dir=dist --exclude=check.sh --exclude=checks.yml . ; then err "possible secret above"; fi

# 3. No personal data: email addresses or US phone numbers.
email='[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
phone='(\(?[0-9]{3}\)?[ .-][0-9]{3}[ .-][0-9]{4})'
if grep -rnIE "$email|$phone" --exclude-dir=.git --exclude-dir=dist --exclude=check.sh --exclude=checks.yml . ; then err "possible email or phone number above; this repo must hold no personal data"; fi

# Guides must match the skills they are built from
tmp=$(mktemp -d); bash scripts/build-guides.sh "$tmp" >/dev/null
diff -rq "$tmp" guides >/dev/null || err "guides/ is out of date (run scripts/build-guides.sh)"
rm -rf "$tmp"

[ $fail -eq 0 ] && echo "All checks passed." || echo "Checks failed."
exit $fail
