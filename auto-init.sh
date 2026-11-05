#!/usr/bin/env bash
# Enable automatic weekly jobs (systemd user timers).
#   ./auto-init.sh             weekly tool updates (update.sh --no-apt, Sat 03:00)
#   ./auto-init.sh --publish   also push changes of THIS repo weekly (owner only, Sun 04:00)
# Disable: systemctl --user disable --now ia-update.timer ia-sync.timer
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

systemctl --user show-environment >/dev/null 2>&1 || {
  echo "systemd user session unavailable (on Debian: sudo apt install dbus-user-session, then re-login)." >&2; exit 1; }

enable() {
  local name="$1"
  mkdir -p "$HOME/.config/systemd/user"
  sed "s#__REPO__#$REPO#g" "$REPO/systemd/$name.service" > "$HOME/.config/systemd/user/$name.service"
  cp "$REPO/systemd/$name.timer" "$HOME/.config/systemd/user/"
  systemctl --user daemon-reload
  systemctl --user enable --now "$name.timer"
  echo "Enabled $name.timer"
}

enable ia-update
if [ "${1:-}" = "--publish" ]; then enable ia-sync; fi
systemctl --user list-timers 'ia-*' --no-pager
