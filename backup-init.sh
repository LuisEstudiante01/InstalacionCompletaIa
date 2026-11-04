#!/usr/bin/env bash
# Create YOUR OWN private backup repo on YOUR GitHub account and enable a weekly timer.
# Nothing is ever pushed to this public repository.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${IA_BACKUP_DIR:-$HOME/.ia-backup}"
NAME="${1:-ia-backup}"

command -v gh >/dev/null || { echo "Install gh and run 'gh auth login' first."; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "Run 'gh auth login' first."; exit 1; }

if [ ! -d "$DEST/.git" ]; then
  mkdir -p "$DEST"; git -C "$DEST" init -q -b main
  gh repo create "$NAME" --private --source="$DEST" --remote=origin
fi
echo "Backup repo: private '$NAME' (local: $DEST). Your memories live ONLY there."

if systemctl --user show-environment >/dev/null 2>&1; then
  mkdir -p "$HOME/.config/systemd/user"
  sed "s#__REPO__#$REPO#g" "$REPO/systemd/ia-backup.service" > "$HOME/.config/systemd/user/ia-backup.service"
  cp "$REPO/systemd/ia-backup.timer" "$HOME/.config/systemd/user/"
  systemctl --user daemon-reload
  systemctl --user enable --now ia-backup.timer
  echo "Weekly timer enabled (Sunday 02:00, catches up if the machine was off)."
else
  echo "systemd user session unavailable; run ./backup.sh manually or from cron."
fi
"$REPO/backup.sh"
