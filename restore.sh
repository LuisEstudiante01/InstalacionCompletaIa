#!/usr/bin/env bash
# Restore YOUR data from YOUR private backup repo onto a fresh machine.
# Usage: ./restore.sh <your-backup-repo-url-or-name>   (run ./install.sh first)
set -euo pipefail
SRC="${1:?Usage: $0 <backup-repo-url | owner/name>}"
DEST="${IA_BACKUP_DIR:-$HOME/.ia-backup}"
[ -d "$DEST/.git" ] || gh repo clone "$SRC" "$DEST" 2>/dev/null || git clone "$SRC" "$DEST"
F="$DEST/files"
put() { [ -e "$F/$1" ] && { mkdir -p "$(dirname "$2")"; [ -e "$2" ] && cp -a "$2" "$2.pre-restore"; cp -r "$F/$1" "$2"; echo "restored $2"; } || true; }
put claude/CLAUDE.md     "$HOME/.claude/CLAUDE.md"
put claude/settings.json "$HOME/.claude/settings.json"
put gitconfig            "$HOME/.gitconfig"
put zshrc                "$HOME/.zshrc"
put herdr/config.toml    "$HOME/.config/herdr/config.toml"
if [ -d "$F/claude/skills" ]; then mkdir -p "$HOME/.claude/skills"; cp -rn "$F/claude/skills/." "$HOME/.claude/skills/"; echo "restored skills (existing kept)"; fi
engram import "$DEST/engram/engram-export.json" && echo "Engram memory imported"
echo "Run 'gentle-ai sync' to refresh official skills."
