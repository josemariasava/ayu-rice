#!/usr/bin/env bash
# Toggle the whole rice between Ayu Mirage (dark) and Ayu Light.
# Swaps the color symlinks for hypr/waybar/rofi/mako + wallpaper, then reloads.
set -euo pipefail

HYPR="$HOME/.config/hypr"
WB="$HOME/.config/waybar"
ROFI="$HOME/.config/rofi"
MAKO="$HOME/.config/mako"
KITTY="$HOME/.config/kitty"

# Detect current theme from the hypr theme.conf symlink target.
current="$(basename "$(readlink -f "$HYPR/theme.conf" 2>/dev/null || echo mirage.conf)" .conf)"
if [ "$current" = "light" ]; then
    theme="mirage"
else
    theme="light"
fi

# Relink every component to the chosen theme.
ln -sf "$HYPR/themes/$theme.conf"       "$HYPR/theme.conf"
ln -sf "$WB/colors-$theme.css"          "$WB/colors.css"
ln -sf "$ROFI/colors-$theme.rasi"       "$ROFI/colors.rasi"
ln -sf "$MAKO/config-$theme"            "$MAKO/config"
ln -sf "$KITTY/colors-$theme.conf"      "$KITTY/theme.conf"

# Wallpaper (hyprpaper is already running with both preloaded).
hyprctl hyprpaper wallpaper ",$HYPR/wallpapers/ayu-$theme.png" >/dev/null 2>&1 || true

# Reload live components.
hyprctl reload >/dev/null 2>&1 || true
makoctl reload >/dev/null 2>&1 || true
# Kitty reloads kitty.conf (and the theme.conf include) on SIGUSR1.
pkill -USR1 -x kitty 2>/dev/null || true
# Waybar has no live reload for colors — restart it.
pkill -x waybar 2>/dev/null || true
sleep 0.2
(waybar >/dev/null 2>&1 &) || true

# GTK apps (nautilus etc.) follow the system color scheme.
if [ "$theme" = "light" ]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null || true
else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
fi

notify-send "Theme" "Switched to Ayu ${theme^}" -t 2000 2>/dev/null || true
