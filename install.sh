#!/usr/bin/env bash
# Ayu Rice — installer.
# Copies the configs in ./.config into ~/.config, backing up anything already
# there. It does NOT touch your package manager or fonts (see README for those).
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.config" && pwd)"
DEST="$HOME/.config"
STAMP="$(date +%Y%m%d-%H%M%S)"
COMPONENTS=(hypr waybar rofi mako wlogout kitty)

echo "Installing Ayu Rice from: $SRC"
echo "Target:                   $DEST"
echo

for comp in "${COMPONENTS[@]}"; do
    if [ -e "$DEST/$comp" ]; then
        backup="$DEST/$comp.bak-$STAMP"
        echo "  • backing up existing $comp  ->  $(basename "$backup")"
        mv "$DEST/$comp" "$backup"
    fi
    # -a preserves the theme symlinks (theme.conf, colors.css, …) verbatim.
    cp -a "$SRC/$comp" "$DEST/"
    echo "  • installed $comp"
done

chmod +x "$DEST/hypr/scripts/"*.sh 2>/dev/null || true

echo
echo "Done. Default theme is Ayu Mirage (dark)."
echo

# Font check — the bar/terminal icons need a Nerd Font.
if ! fc-match "JetBrainsMono Nerd Font" 2>/dev/null | grep -qi "jetbrains"; then
    echo "⚠  'JetBrainsMono Nerd Font' not found — bar/terminal glyphs will be blank."
    echo "   Install it with:"
    echo "     mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd && cd ~/.local/share/fonts/JetBrainsMonoNerd"
    echo "     curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    echo "     unzip -o JetBrainsMono.zip && fc-cache -f"
    echo
fi

cat <<'NOTE'
Next steps:
  • Log into a Hyprland session (or run `hyprctl reload` if already in one).
  • Toggle dark/light with  Super+Shift+T.
  • Keybinding cheat sheet:  ~/.config/hypr/KEYBINDS.md
NOTE
