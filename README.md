# InstalacionCompletaIa

One-command setup of a complete terminal + AI-coding-agent environment on **Ubuntu / Debian**
(also works on WSL2 with systemd): zsh + Powerlevel10k, Neovim (LazyVim), herdr, tmux tools,
Claude Code, OpenCode and Antigravity (agy) installation and configuration, and persistent agent memory ([Engram](https://github.com/Gentleman-Programming))
with the official [gentle-ai](https://github.com/Gentleman-Programming) skills.

> This repository contains **no personal data**. It is read-only for everyone except its owner:
> clone it, or fork it to customize.

## Install

    sudo apt-get install -y git curl
    git clone https://github.com/LuisEstudiante01/InstalacionCompletaIa.git ~/InstalacionCompletaIa
    cd ~/InstalacionCompletaIa && ./install.sh      # or: packages | tools | link | wezterm

Existing files are moved to `~/.ia-install-backup/<timestamp>/` before anything is linked.
Run `gh auth login` first so gentle-ai can reach GitHub. WezTerm (+ Iosevka Nerd Font) installs on desktops via `./install.sh wezterm`; on Windows+WSL use `wezterm/wezterm-windows-wsl.lua`.

## Update everything

    ./update.sh            # add --no-apt to skip the system (sudo) upgrade

Runs Homebrew, `gentle-ai sync`, Claude Code, OpenCode, agy, herdr, codegraph and apt, in that order.
A failing step is reported at the end and never blocks the rest.

## Automatic weekly jobs

    ./auto-init.sh              # weekly tool updates (Sat 03:00, apt is skipped: no sudo when unattended)
    ./auto-init.sh --publish    # owner only: also push this repo's changes weekly (Sun 04:00)

`sync-repo.sh` only commits changes to files git already tracks, and aborts if the added lines contain
an email, token, private key or `/home/<user>/` path. Disable: `systemctl --user disable --now ia-update.timer ia-sync.timer`.

## Back up YOUR data (private, automatic, near-zero cost)

    ./backup-init.sh [repo-name]

This creates a **private repo on your own GitHub account** (default name `ia-backup`) and enables a
weekly systemd timer (Sunday 02:00; runs on next start if the machine was off). `backup.sh` exports your
Engram memory and copies `CLAUDE.md`, `settings.json`, your skills, `.gitconfig`, `.zshrc`, herdr and
Neovim config into that private repo. Nothing from you is ever pushed here.

## Restore on a new machine

    ./install.sh
    ./restore.sh <you>/ia-backup

## Layout

| Path | Purpose |
|---|---|
| `install.sh` | apt packages, Homebrew tools, gentle-ai, config linking |
| `auto-init.sh`, `sync-repo.sh` | weekly automatic updates and (owner) repo push |
| `update.sh` | update every tool in one command |
| `backup-init.sh`, `backup.sh`, `restore.sh` | your private backup and restore |
| `systemd/` | weekly timer units used by `backup-init.sh` |
| `nvim/`, `herdr/`, `zsh/`, `claude/` | base configuration shipped as a starting point |

## Notes

Review `install.sh` before running it: it installs software and uses `sudo`. It has been syntax-checked
but not yet run end-to-end on a clean machine. Licensed under MIT.
