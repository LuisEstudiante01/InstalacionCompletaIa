#!/usr/bin/env bash
# Update everything installed by install.sh. A failing step never stops the others.
# Usage: ./update.sh [--no-apt]   (--no-apt skips the system upgrade, which needs sudo)
set -uo pipefail

export PATH="$HOME/.local/bin:$HOME/.opencode/bin:/home/linuxbrew/.linuxbrew/bin:$PATH"
FAILED=()

log()  { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }
# run NAME CMD...: run a step only if its tool exists, record failures
run() {
  local name="$1" bin="$2"; shift 2
  if ! command -v "$bin" >/dev/null 2>&1; then printf 'skip %s (not installed)\n' "$name"; return; fi
  log "$name"
  "$@" || { FAILED+=("$name"); printf '\033[1;33m!!\033[0m %s failed, continuing\n' "$name" >&2; }
}

run "Homebrew update"   brew brew update
run "Homebrew upgrade"  brew brew upgrade
# After brew: sync refreshes skills/config to the installed gentle-ai version.
run "gentle-ai sync"    gentle-ai gentle-ai sync
run "Claude Code"       claude claude update
run "OpenCode"          opencode opencode upgrade
run "agy"               agy agy update
run "herdr"             herdr herdr update
run "codegraph"         codegraph codegraph upgrade

if [ "${1:-}" != "--no-apt" ]; then
  run "System packages (apt, incl. WezTerm)" sudo sh -c 'apt-get update && apt-get upgrade -y'
fi

log "Summary"
if [ ${#FAILED[@]} -eq 0 ]; then echo "Everything updated."
else printf 'Failed steps: %s\n' "${FAILED[*]}"; exit 1; fi
