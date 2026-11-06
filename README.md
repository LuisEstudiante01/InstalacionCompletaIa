#Instalacion-Completa-ia

**[English](#english) | [Español](#español)**

---

## Español

Instalación de un solo comando de un entorno completo de terminal y agentes de IA para programar en **Ubuntu / Debian**
(también funciona en WSL2 con systemd): zsh + Powerlevel10k, Neovim (LazyVim), herdr, WezTerm, instalación y configuración de
Claude Code, OpenCode y Antigravity (agy), y memoria persistente para agentes con [Engram](https://github.com/Gentleman-Programming/engram)
y las skills oficiales de [gentle-ai](https://github.com/Gentleman-Programming/gentle-ai).

> Este repositorio **no contiene datos personales**. Solo su dueño puede modificarlo:
> clónalo para usarlo o haz un fork para personalizarlo.

### Instalar

    sudo apt-get install -y git curl
    git clone https://github.com/LuisEstudiante01/InstalacionCompletaIa.git ~/InstalacionCompletaIa
    cd ~/InstalacionCompletaIa && ./install.sh      # o: packages | tools | link | wezterm

Los archivos existentes se mueven a `~/.ia-install-backup/<fecha>/` antes de enlazar cualquier configuración.
Ejecuta `gh auth login` antes, para que gentle-ai pueda acceder a GitHub. WezTerm (con la fuente Iosevka Nerd Font) se instala
en equipos con escritorio mediante `./install.sh wezterm`; en Windows con WSL usa `wezterm/wezterm-windows-wsl.lua`.

Por defecto gentle-ai se instala para Claude Code y OpenCode. Para sumar otros agentes:
`IA_AGENTS=claude-code,opencode,antigravity ./install.sh tools`.

### Actualizar todo

    ./update.sh            # agrega --no-apt para omitir la actualización del sistema (requiere sudo)

Ejecuta, en este orden: Homebrew, `gentle-ai sync`, Claude Code, OpenCode, agy, herdr, codegraph y apt.
Si un paso falla, se informa al final y no bloquea a los demás.

### Tareas semanales automáticas

    ./auto-init.sh              # actualiza las herramientas cada semana (sábado 03:00; omite apt porque no hay sudo sin supervisión)
    ./auto-init.sh --publish    # solo para el dueño del repo: además sube los cambios de este repo cada semana (domingo 04:00)

`sync-repo.sh` solo confirma cambios en archivos que git ya sigue, y se cancela si las líneas agregadas contienen
un correo, un token, una clave privada o una ruta `/home/<usuario>/`.
Para desactivar: `systemctl --user disable --now ia-update.timer ia-sync.timer`.

### Respalda TUS datos (privado, automático, casi sin consumo)

    ./backup-init.sh [nombre-del-repo]

Crea un **repositorio privado en tu propia cuenta de GitHub** (por defecto `ia-backup`) y activa un timer semanal de systemd
(domingo 02:00; si el equipo estaba apagado, corre en el próximo arranque). `backup.sh` exporta tu memoria de Engram y copia
`CLAUDE.md`, `settings.json`, tus skills, `.gitconfig`, `.zshrc` y la configuración de herdr y Neovim a ese repositorio privado.
Nada tuyo se sube jamás a este repositorio.

### Restaurar en una máquina nueva

    ./install.sh
    ./restore.sh <tu-usuario>/ia-backup

### Estructura

| Ruta | Para qué sirve |
|---|---|
| `install.sh` | paquetes de apt, herramientas de Homebrew, gentle-ai y enlace de configuración |
| `update.sh` | actualiza todas las herramientas con un solo comando |
| `auto-init.sh`, `sync-repo.sh` | actualizaciones semanales automáticas y (solo el dueño) subida de cambios del repo |
| `backup-init.sh`, `backup.sh`, `restore.sh` | tu respaldo privado y su restauración |
| `systemd/` | unidades de los timers semanales usadas por `backup-init.sh` y `auto-init.sh` |
| `nvim/`, `herdr/`, `zsh/`, `wezterm/`, `claude/` | configuración base que se entrega como punto de partida |

### Créditos

Este proyecto es solo un instalador y un conjunto de configuraciones iniciales. El trabajo real lo hace el ecosistema de
[Gentleman Programming](https://github.com/Gentleman-Programming). Muchas gracias a su autor y a sus colaboradores por crear
estas herramientas y mantenerlas de código abierto.

| Proyecto | Qué hace |
|---|---|
| [gentle-ai](https://github.com/Gentleman-Programming/gentle-ai) | Configura los agentes de IA que ya usas (Claude Code, OpenCode, Codex, Pi y más): memoria persistente, Organic Driven Development, skills seleccionadas, servidores MCP, personas y revisión acotada opcional. |
| [gentle-shell](https://github.com/Gentleman-Programming/gentle-shell) (antes `gentle-pi`) | Un espacio de trabajo de terminal nativo de Pi para desarrollar con IA: agentes de código en paralelo, tareas en vivo, diffs de Git, memoria persistente y control de permisos en una sola interfaz. |
| [engram](https://github.com/Gentleman-Programming/engram) | Memoria persistente para agentes de IA: un único binario en Go con SQLite + FTS5, servidor MCP, API HTTP, CLI y TUI. |
| [gentleman-guardian-angel](https://github.com/Gentleman-Programming/gentleman-guardian-angel) (`gga`) | Revisión de código con IA, independiente del proveedor, que hace cumplir tus estándares (Claude, Gemini, Codex, Ollama). |
| [homebrew-tap](https://github.com/Gentleman-Programming/homebrew-tap) | El tap de Homebrew que distribuye gentle-ai, engram y gga; lo usa `install.sh`. |
| [gentle-wiki](https://github.com/Gentleman-Programming/gentle-wiki) | Guías y referencias mantenidas por la comunidad sobre desarrollo de software asistido por IA y el ecosistema Gentleman Programming. |
| [gentle-ai-community-docs](https://github.com/Gentleman-Programming/gentle-ai-community-docs) | La documentación comunitaria bilingüe (inglés/español) de Gentle AI, en [docs-gentle-ai.netlify.app](https://docs-gentle-ai.netlify.app); también se ofrece a los agentes de código mediante un servidor MCP de solo lectura. |
| [Gentleman.Dots](https://github.com/Gentleman-Programming/Gentleman.Dots) | La configuración personal de LazyVim del autor. |

También se usan: [herdr](https://herdr.dev), [WezTerm](https://wezterm.org), [OpenCode](https://opencode.ai),
[Claude Code](https://claude.ai) y [Homebrew](https://brew.sh).
Este repositorio es un proyecto comunitario independiente y no está afiliado ni respaldado por ninguno de ellos.

### Notas

Revisa `install.sh` antes de ejecutarlo: instala software y usa `sudo`. La instalación (`install.sh`) se probó en una máquina
virtual con Debian. Los scripts `update.sh`, `auto-init.sh`, `backup-init.sh`, `backup.sh` y `restore.sh` todavía no se
probaron de punta a punta. Licencia MIT.

[↑ Volver arriba / Back to top](#Instalacion-Completa-ia)

---

## English

One-command setup of a complete terminal + AI-coding-agent environment on **Ubuntu / Debian**
(also works on WSL2 with systemd): zsh + Powerlevel10k, Neovim (LazyVim), herdr, WezTerm, installation and configuration of
Claude Code, OpenCode and Antigravity (agy), and persistent agent memory with [Engram](https://github.com/Gentleman-Programming/engram)
and the official [gentle-ai](https://github.com/Gentleman-Programming/gentle-ai) skills.

> This repository contains **no personal data**. It is read-only for everyone except its owner:
> clone it, or fork it to customize.

### Install

    sudo apt-get install -y git curl
    git clone https://github.com/LuisEstudiante01/InstalacionCompletaIa.git ~/InstalacionCompletaIa
    cd ~/InstalacionCompletaIa && ./install.sh      # or: packages | tools | link | wezterm

Existing files are moved to `~/.ia-install-backup/<timestamp>/` before anything is linked.
Run `gh auth login` first so gentle-ai can reach GitHub. WezTerm (+ Iosevka Nerd Font) installs on desktops via
`./install.sh wezterm`; on Windows+WSL use `wezterm/wezterm-windows-wsl.lua`.

By default gentle-ai is installed for Claude Code and OpenCode. To add more agents:
`IA_AGENTS=claude-code,opencode,antigravity ./install.sh tools`.

### Update everything

    ./update.sh            # add --no-apt to skip the system (sudo) upgrade

Runs Homebrew, `gentle-ai sync`, Claude Code, OpenCode, agy, herdr, codegraph and apt, in that order.
A failing step is reported at the end and never blocks the rest.

### Automatic weekly jobs

    ./auto-init.sh              # weekly tool updates (Sat 03:00, apt is skipped: no sudo when unattended)
    ./auto-init.sh --publish    # owner only: also push this repo's changes weekly (Sun 04:00)

`sync-repo.sh` only commits changes to files git already tracks, and aborts if the added lines contain
an email, token, private key or `/home/<user>/` path. Disable: `systemctl --user disable --now ia-update.timer ia-sync.timer`.

### Back up YOUR data (private, automatic, near-zero cost)

    ./backup-init.sh [repo-name]

This creates a **private repo on your own GitHub account** (default name `ia-backup`) and enables a
weekly systemd timer (Sunday 02:00; runs on next start if the machine was off). `backup.sh` exports your
Engram memory and copies `CLAUDE.md`, `settings.json`, your skills, `.gitconfig`, `.zshrc`, herdr and
Neovim config into that private repo. Nothing from you is ever pushed here.

### Restore on a new machine

    ./install.sh
    ./restore.sh <you>/ia-backup

### Layout

| Path | Purpose |
|---|---|
| `install.sh` | apt packages, Homebrew tools, gentle-ai, config linking |
| `update.sh` | update every tool in one command |
| `auto-init.sh`, `sync-repo.sh` | weekly automatic updates and (owner only) repo push |
| `backup-init.sh`, `backup.sh`, `restore.sh` | your private backup and restore |
| `systemd/` | weekly timer units used by `backup-init.sh` and `auto-init.sh` |
| `nvim/`, `herdr/`, `zsh/`, `wezterm/`, `claude/` | base configuration shipped as a starting point |

### Credits

This project is only an installer and a set of starting configs. The real work is done by the
[Gentleman Programming](https://github.com/Gentleman-Programming) ecosystem. Huge thanks to its author and
contributors for building these tools and keeping them open source.

| Project | What it does |
|---|---|
| [gentle-ai](https://github.com/Gentleman-Programming/gentle-ai) | Configures the AI coding agents you already use (Claude Code, OpenCode, Codex, Pi and more): persistent memory, Organic Driven Development, curated skills, MCP servers, personas and optional bounded review. |
| [gentle-shell](https://github.com/Gentleman-Programming/gentle-shell) (formerly `gentle-pi`) | A Pi-native terminal workspace for AI-assisted development: parallel coding agents, live tasks, Git diffs, persistent memory and permission controls in one interface. |
| [engram](https://github.com/Gentleman-Programming/engram) | Persistent memory for AI coding agents: a single Go binary with SQLite + FTS5, an MCP server, HTTP API, CLI and TUI. |
| [gentleman-guardian-angel](https://github.com/Gentleman-Programming/gentleman-guardian-angel) (`gga`) | Provider-agnostic AI code review that enforces your coding standards (Claude, Gemini, Codex, Ollama). |
| [homebrew-tap](https://github.com/Gentleman-Programming/homebrew-tap) | The Homebrew tap that distributes gentle-ai, engram and gga, used by `install.sh`. |
| [gentle-wiki](https://github.com/Gentleman-Programming/gentle-wiki) | Community-maintained guides and references on AI-assisted software development and the Gentleman Programming ecosystem. |
| [gentle-ai-community-docs](https://github.com/Gentleman-Programming/gentle-ai-community-docs) | The bilingual (English/Spanish) community documentation for Gentle AI, at [docs-gentle-ai.netlify.app](https://docs-gentle-ai.netlify.app), also served to coding agents through a read-only MCP server. |
| [Gentleman.Dots](https://github.com/Gentleman-Programming/Gentleman.Dots) | The author's personal LazyVim configuration. |

Also used: [herdr](https://herdr.dev), [WezTerm](https://wezterm.org), [OpenCode](https://opencode.ai),
[Claude Code](https://claude.ai) and [Homebrew](https://brew.sh).
This repository is an independent community project and is not affiliated with or endorsed by any of them.

### Notes

Review `install.sh` before running it: it installs software and uses `sudo`. `install.sh` has been tested on a Debian
virtual machine. `update.sh`, `auto-init.sh`, `backup-init.sh`, `backup.sh` and `restore.sh` have not yet been run
end-to-end. Licensed under MIT.

[↑ Back to top / Volver arriba](#instalacioncompletaia)
