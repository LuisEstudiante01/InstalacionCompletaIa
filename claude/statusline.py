#!/usr/bin/env python3
import json
import os
import subprocess
import sys
from datetime import datetime
from zoneinfo import ZoneInfo

BA = ZoneInfo("America/Argentina/Buenos_Aires")
EFFORT = {
    "low": ("Bajo", "\033[38;2;166;227;161m"),
    "medium": ("Medio", "\033[38;2;250;179;135m"),
    "high": ("Alto", "\033[38;2;243;139;168m"),
    "xhigh": ("Muy alto", "\033[38;2;213;175;255m"),
    "max": ("Máximo", "\033[38;2;245;194;231m"),
}
TEXT = "\033[38;2;205;214;244m"
DAYS = ("Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom")
RESET = "\033[0m"
DIM = "\033[2m"
CYAN = "\033[38;2;137;220;235m"
YELLOW = "\033[38;2;249;226;175m"
GREEN = "\033[38;2;166;227;161m"
ORANGE = "\033[38;2;250;179;135m"
RED = "\033[38;2;243;139;168m"
GRAY = "\033[38;2;108;112;134m"
BAR_BLUE = "\033[38;2;148;226;213m"
BADGE_FG ="\033[38;2;20;20;28m"
BADGE_BLUE = "\033[48;2;137;180;250m" + BADGE_FG
BADGE_GREEN = "\033[48;2;166;227;161m" + BADGE_FG
BADGE_LAVENDER ="\033[48;2;213;175;255m" + BADGE_FG


def git(cwd, *args):
    try:
        out = subprocess.run(
            ["git", "-C", cwd, *args], capture_output=True, text=True, timeout=2
        )
        return out.stdout.strip() if out.returncode == 0 else ""
    except Exception:
        return ""


def fmt_tokens(n):
    if n >= 1_000_000:
        return f"{n / 1_000_000:.1f}M".replace(".0M", "M")
    if n >= 1000:
        return f"{n // 1000}k"
    return str(n)


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        return

    cwd = (data.get("workspace") or {}).get("current_dir") or data.get("cwd") or os.getcwd()
    home = os.path.expanduser("~")
    shown = "~" + cwd[len(home):] if cwd.startswith(home) else cwd

    parts = [f"{CYAN}{shown}{RESET}"]

    branch = git(cwd, "branch", "--show-current")
    if branch:
        seg = f"{YELLOW}{branch}"
        if git(cwd, "status", "--porcelain"):
            seg += " *"
        counts = git(cwd, "rev-list", "--left-right", "--count", "@{upstream}...HEAD").split()
        if len(counts) == 2:
            behind, ahead = int(counts[0]), int(counts[1])
            if ahead:
                seg += f" {GREEN}↑{ahead}"
            if behind:
                seg += f" {RED}↓{behind}"
        parts.append(seg + RESET)

    ctx = data.get("context_window") or {}
    pct = ctx.get("used_percentage")
    if pct is not None:
        pct = float(pct)
        color = GREEN if pct < 50 else ORANGE if pct < 80 else RED
        filled = min(10, max(1 if pct > 0 else 0, round(pct / 10)))
        bar = f"{BAR_BLUE}{'█' * filled}{GRAY}{'░' * (10 - filled)}"
        used = (ctx.get("total_input_tokens") or 0) + (ctx.get("total_output_tokens") or 0)
        size = ctx.get("context_window_size") or 0
        tail = f" {GRAY}{fmt_tokens(used)}/{fmt_tokens(size)}" if size else ""
        parts.append(f"{bar} {color}{pct:.0f}%{tail}{RESET}")

    limits = data.get("rate_limits") or {}
    for key, label, bg in (
        ("five_hour", "5h", BADGE_BLUE),
        ("seven_day", "7d", BADGE_LAVENDER),
    ):
        win = limits.get(key) or {}
        if win.get("used_percentage") is None:
            continue
        if win.get("resets_at"):
            secs = max(0, int(win["resets_at"] - datetime.now(BA).timestamp()))
            d, h, m = secs // 86400, secs % 86400 // 3600, secs % 3600 // 60
            label = f"{d}d {h}h" if d else f"{h}h {m}m"
        seg = f"{label} {win['used_percentage']:.0f}%"
        if win.get("resets_at"):
            when = datetime.fromtimestamp(win["resets_at"], BA)
            day = f"{DAYS[when.weekday()]} {when.day}" if key == "seven_day" else DAYS[when.weekday()]
            seg += f" ⏳ {day} {when:%H:%M}"
        parts.append(f"{bg} {seg} {RESET}")

    now = datetime.now(BA)
    parts.append(f"{BADGE_GREEN} {DAYS[now.weekday()]} {now:%H:%M} {RESET}")

    print(f" {GRAY}•{RESET} ".join(parts))

    model = (data.get("model") or {}).get("display_name")
    if model:
        level = (data.get("effort") or {}).get("level")
        label, tint = EFFORT.get(level, (level, GRAY))
        plain = f"{model} · {label}" if level else model
        tail = f" {GRAY}· {tint}{label}" if level else ""
        try:
            width = int(os.environ.get("COLUMNS", "0"))
        except ValueError:
            width = 0
        pad = "⠀" * max(0, width - len(plain) - 10)
        print(f"{pad}{TEXT}{model}{tail}{RESET}")


main()
