#!/usr/bin/env bash
# Owner-only: commit and push CHANGES TO TRACKED FILES of this repo, after a safety scan.
# New (untracked) files are never added automatically. Aborts if the diff looks sensitive.
set -euo pipefail
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git add -u
if git diff --cached --quiet; then echo "Nothing to sync."; exit 0; fi

# Safety scan on the lines being added: tokens/keys/emails/home paths of a specific user.
PATTERN='gh[opsu]_[A-Za-z0-9]{20}|sk-[A-Za-z0-9]{20}|AKIA[A-Z0-9]{12}|-----BEGIN [A-Z ]*PRIVATE KEY|[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[a-z]{2,}|/home/[a-z][a-z0-9_-]*/'
if git diff --cached -U0 | grep -E '^\+[^+]' | grep -Eq "$PATTERN"; then
  git reset -q
  echo "ABORTED: the diff contains something that looks personal or secret. Review with 'git diff' and commit by hand." >&2
  exit 2
fi

git commit -qm "chore: auto-sync $(date +%Y-%m-%d)"
git push
