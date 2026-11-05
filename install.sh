#!/usr/bin/env bash
# Complete terminal + AI-agent environment for Ubuntu/Debian. Idempotent.
# Usage: ./install.sh [all|packages|tools|link]
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.ia-install-backup/$(date +%Y%m%d-%H%M%S)"
BREW="/home/linuxbrew/.linuxbrew/bin/brew"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }

step_packages() {
  log "System packages (apt)"
  sudo apt-get update
  sudo apt-get install -y build-essential curl file git procps zsh tmux python3 unzip
}

step_tools() {
  log "Homebrew"
  if [ ! -x "$BREW" ]; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$("$BREW" shellenv)"

  log "Tap + formulae"
  brew tap gentleman-programming/tap
  # Recent Homebrew refuses third-party taps until trusted; older versions lack 'brew trust'.
  brew trust gentleman-programming/tap 2>/dev/null || true
  brew install --formula gentleman-programming/tap/gentle-ai gentleman-programming/tap/engram \
    gentleman-programming/tap/gga
  brew install gh neovim git lazygit fzf fzf-tab eza bat fd atuin carapace node

  log "codegraph (npm)"
  npm install -g @colbymchenry/codegraph

  log "oh-my-zsh"
  [ -d "$HOME/.oh-my-zsh" ] || RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  log "opencode"
  command -v opencode >/dev/null || curl -fsSL https://opencode.ai/install | bash

  command -v herdr >/dev/null || warn "herdr not found: install it manually (see its docs) and re-run './install.sh tools'."

  log "gentle-ai (official skills, agents, personas)"
  gh auth status >/dev/null 2>&1 || warn "Run 'gh auth login' for GitHub access."
  gentle-ai install || warn "gentle-ai install may need interaction; run 'gentle-ai' manually."
}

# link SRC DEST: move an existing real file aside, then symlink
link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then return; fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP"; mv "$dest" "$BACKUP/$(echo "$dest" | tr / _)"
    warn "Moved existing $dest -> $BACKUP"
  fi
  ln -s "$src" "$dest"
}

step_link() {
  log "Linking config"
  link "$REPO/nvim"                 "$HOME/.config/nvim"
  link "$REPO/herdr/config.toml"    "$HOME/.config/herdr/config.toml"
  link "$REPO/zsh/.zshrc"           "$HOME/.zshrc"
  link "$REPO/zsh/.zshenv"          "$HOME/.zshenv"
  link "$REPO/zsh/.p10k.zsh"        "$HOME/.p10k.zsh"
  link "$REPO/claude/statusline.py" "$HOME/.claude/statusline.py"
  link "$REPO/claude/hooks"         "$HOME/.claude/hooks"
  link "$REPO/claude/output-styles" "$HOME/.claude/output-styles"

  # settings.json is copied (not linked) so Claude Code can edit it. Never overwrite yours.
  mkdir -p "$HOME/.claude"
  if [ ! -e "$HOME/.claude/settings.json" ]; then
    sed "s#__HOME__#$HOME#g" "$REPO/claude/settings.json" > "$HOME/.claude/settings.json"
  else
    warn "~/.claude/settings.json exists; kept. Template: $REPO/claude/settings.json"
  fi

  git config --global user.name  >/dev/null || warn "Set your git identity: git config --global user.name 'You'"
  git config --global user.email >/dev/null || warn "Set your git identity: git config --global user.email 'you@example.com'"
  if [ "$(basename "${SHELL:-}")" != "zsh" ] && command -v zsh >/dev/null; then
    warn "Set zsh as default shell: chsh -s \$(command -v zsh)"
  fi
}

case "${1:-all}" in
  packages) step_packages ;;
  tools)    step_tools ;;
  link)     step_link ;;
  all)      step_packages; step_tools; step_link ;;
  *) echo "Usage: $0 [all|packages|tools|link]"; exit 1 ;;
esac
log "Done. To protect YOUR data with automatic weekly backups, run: ./backup-init.sh"
