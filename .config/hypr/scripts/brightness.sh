#!/usr/bin/env bash
# Adjust screen brightness in fixed steps, CLAMPED to [MIN, MAX] so the backlight
# can never be dimmed all the way to black (you'd lose the screen otherwise).
#
#   Usage:  brightness.sh up | down
#
# Called from the Fn brightness keys (hyprland.conf) and the Waybar backlight
# module. Edit the three numbers below to taste.
set -euo pipefail

STEP=5     # how many % each press changes
MIN=10     # never go below this (floor — keeps the screen visible)
MAX=100    # never go above this

# `brightnessctl -m` prints:  name,class,current_raw,PERCENT,max_raw
# e.g.  intel_backlight,backlight,24242,100%,24242   -> field 4 is the percent.
cur=$(brightnessctl -m | cut -d',' -f4 | tr -d '%')

case "${1:-}" in
    up)   new=$(( cur + STEP )) ;;
    down) new=$(( cur - STEP )) ;;
    *)    echo "usage: $(basename "$0") up|down" >&2; exit 1 ;;
esac

# Clamp into range.
(( new < MIN )) && new=$MIN
(( new > MAX )) && new=$MAX

brightnessctl set "${new}%" >/dev/null
