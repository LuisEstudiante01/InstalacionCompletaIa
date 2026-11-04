#!/usr/bin/env bash
# Back up YOUR data into YOUR private repo (see backup-init.sh).
set -euo pipefail
DEST="${IA_BACKUP_DIR:-$HOME/.ia-backup}"
[ -d "$DEST/.git" ] || { echo "Run ./backup-init.sh first."; exit 1; }
cd "$DEST"

mkdir -p engram files
engram export --all engram/engram-export.json
copy() { [ -e "$1" ] && { mkdir -p "files/$(dirname "$2")"; rm -rf "files/$2"; cp -rL "$1" "files/$2"; } || true; }
copy "$HOME/.claude/CLAUDE.md"          claude/CLAUDE.md
copy "$HOME/.claude/settings.json"      claude/settings.json
copy "$HOME/.claude/skills"             claude/skills
copy "$HOME/.gitconfig"                 gitconfig
copy "$HOME/.zshrc"                     zshrc
copy "$HOME/.config/herdr/config.toml" herdr/config.toml
copy "$HOME/.config/nvim"               nvim
rm -rf files/nvim/spell files/nvim/.git

git add -A
if git diff --cached --quiet; then echo "Nothing to back up."; exit 0; fi
git commit -qm "chore: backup $(date +%Y-%m-%d)"
git push -u origin main
