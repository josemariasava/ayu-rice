# Managing the Ayu Rice

A practical, self-contained guide to running and tweaking this setup yourself —
colors, styling, wallpaper, keybinds, and pushing changes to GitHub.

> **The golden rule:** your *live* config lives in `~/.config/…`. This git repo
> (`~/ayu-rice/`) is a **separate copy** you sync to by hand. Editing files in
> `~/.config` changes your running desktop; it does **not** touch the repo until
> you copy the files over and commit (see [§7](#7-saving-changes-to-github)).

---

## 1. The big picture

**Components (all installed from apt):** Hyprland (compositor) · waybar (top bar)
· rofi (app launcher) · mako (notifications) · hyprpaper (wallpaper) · hyprlock
(lock screen) · hypridle (idle/auto-lock) · wlogout (power menu) · kitty (terminal).

**Where each one's config lives:**

| Component | Config dir | Main file |
|---|---|---|
| Hyprland | `~/.config/hypr/` | `hyprland.conf` |
| Waybar | `~/.config/waybar/` | `config.jsonc`, `style.css` |
| Rofi | `~/.config/rofi/` | `config.rasi` |
| Mako | `~/.config/mako/` | `config` (symlink) |
| Wallpaper | `~/.config/hypr/` | `hyprpaper.conf` |
| Lock screen | `~/.config/hypr/` | `hyprlock.conf` |
| Idle/auto-lock | `~/.config/hypr/` | `hypridle.conf` |
| Power menu | `~/.config/wlogout/` | `layout`, `style.css` |
| Terminal | `~/.config/kitty/` | `kitty.conf` |

**Keybind cheat sheet:** `~/.config/hypr/KEYBINDS.md` (bound to a key in Hyprland —
check that file). The default modifier `$mainMod` is the **Super** (Windows) key.

---

## 2. How theming works (read this first)

Every themeable component has **two color files** — a `*-mirage` (dark) and a
`*-light` variant — plus a **symlink** that points at the "active" one. The
toggle script just re-points all the symlinks at once and reloads everything.

```
hypr/theme.conf      ->  themes/mirage.conf      or  themes/light.conf
waybar/colors.css    ->  colors-mirage.css       or  colors-light.css
rofi/colors.rasi     ->  colors-mirage.rasi      or  colors-light.rasi
mako/config          ->  config-mirage           or  config-light
kitty/theme.conf     ->  colors-mirage.conf      or  colors-light.conf
```

### Switch theme
Press **`Super+Shift+T`**, or run:
```bash
~/.config/hypr/scripts/theme-switch.sh
```
It flips the symlinks, swaps the wallpaper, reloads Hyprland/mako/kitty, restarts
waybar, and flips GTK apps (Nautilus etc.) to light/dark. The lock screen follows
automatically because `hyprlock.conf` sources the same `theme.conf`.

### Check which theme is active
```bash
readlink ~/.config/hypr/theme.conf    # -> themes/mirage.conf or themes/light.conf
```

---

## 3. Changing colors

### 3a. Hyprland itself (borders, gaps' tint, lock screen)
Edit the palette variables in **both** theme files so dark and light stay in sync:
- `~/.config/hypr/themes/mirage.conf`
- `~/.config/hypr/themes/light.conf`

Available variables (same names in both files, different values):

| Variable | Mirage | Light | Used for |
|---|---|---|---|
| `$accent` | `#ffcc66` | `#f29718` | active border, highlights |
| `$accent2` | `#ffa659` | `#fa8532` | border gradient end |
| `$background` | `#1f2430` | `#f8f9fa` | base background |
| `$surface` | `#242936` | `#fcfcfc` | panels / lock inner ring |
| `$inactive` | `#3d4556` | `#c5cdd6` | inactive window border |
| `$foreground` | `#cccac2` | `#5c6166` | text |
| `$muted` | `#707a8c` | `#828e9f` | dim text |
| `$urgent` | `#f28779` | `#f07171` | errors / lock fail |
| `$success` | `#d5ff80` | `#86b300` | lock "verifying" |
| `$wallpaper` | `ayu-mirage.png` | `ayu-light.png` | lock bg + theme wallpaper |

Format is `rgb(rrggbb)` (no `#`). After editing:
```bash
hyprctl reload          # apply
hyprctl configerrors    # should print "no errors"
```

### 3b. Waybar colors
Edit `~/.config/waybar/colors-mirage.css` and `colors-light.css`. They use GTK
`@define-color name #hex;` (note: `#hex`, **with** the hash here). Names: `bg`,
`bg-alt`, `panel`, `fg`, `muted`, `accent`, `accent2`, `green`, `blue`, `red`.
Then restart waybar: `pkill waybar; waybar &` (or just `Super+Shift+T` twice).

### 3c. Rofi colors
Edit `~/.config/rofi/colors-mirage.rasi` / `colors-light.rasi`. Format
`name: #rrggbbaa;` (8-digit, last two = alpha). Names: `bg`, `surface`, `fg`,
`muted`, `accent`. **Gotcha:** never make a variable reference itself
(`accent: @accent;`) — rofi throws a "variable failed to resolve" box on launch.

### 3d. Terminal (kitty) colors
Edit `~/.config/kitty/colors-mirage.conf` / `colors-light.conf` (standard kitty
16-color scheme). Running terminals live-reload on `pkill -USR1 -x kitty`.
**Don't** set `background_opacity` in kitty — transparency comes from a Hyprland
window rule (`opacity 0.92 0.88`); setting both double-dims.

### 3e. Notifications (mako) colors
Edit `~/.config/mako/config-mirage` / `config-light`, then `makoctl reload`.

---

## 4. Changing style (not just color)

- **Borders / gaps / rounding:** in `hyprland.conf`, the `general { }` and
  `decoration { }` blocks. Current look: `rounding = 0` (square corners),
  `shadow { enabled = false }`, accent gradient on the active border.
- **Window transparency / floating / sizing:** the `windowrule = …` lines near
  the bottom of `hyprland.conf`. **Hyprland 0.53 syntax** (important — the old
  syntax silently fails):
  ```
  windowrule = match:class ^(kitty)$, opacity 0.92 0.88
  windowrule = match:class ^(pavucontrol)$, float on
  windowrule = match:class ^(pavucontrol)$, size 60% 60%, center on
  layerrule  = match:namespace ^(rofi)$, blur on
  ```
  State rules need an explicit `on` (`float on`, `pin on`, `center on`); it's
  `float`, not `floating`. `windowrulev2` is deprecated — don't use it.
- **Waybar layout & modules:** `~/.config/waybar/config.jsonc`
  (`modules-left/center/right` arrays + each module's block). Visual styling
  (padding, panel shape, frosted look) is in `style.css`.
- **Bar glyphs/icons:** the font is *JetBrainsMono Nerd Font*. If you add an icon,
  paste the **actual glyph codepoint** — some editors strip pasted glyphs to blank
  spaces. Known-good codepoints are listed in the project notes; avoid
  `f538/f5dd/f6a9/f6ff` (they render as tofu in this font).
- **Lock screen look:** `hyprlock.conf` (uses the `$accent/$surface/$foreground/…`
  vars, so it re-themes for free).
- **Power menu:** `~/.config/wlogout/{layout,style.css}`. It has 5 buttons; it's
  launched with `-b 5` (bound to `Super+Shift+E`) so they sit in one row.

After any Hyprland edit: `hyprctl reload` then `hyprctl configerrors`.
**Tip:** test uncertain syntax live *before* saving it to the file with
`hyprctl keyword <name> "<value>"`.

---

## 5. Changing the wallpaper

Two wallpapers are preloaded by hyprpaper, one per theme:
`~/.config/hypr/wallpapers/ayu-mirage.png` and `ayu-light.png`.

**To replace one:** drop your image in `~/.config/hypr/wallpapers/`, then either
keep the same filenames (simplest) or update the paths in **three** places:
1. `~/.config/hypr/hyprpaper.conf` — the `preload` + `wallpaper` lines
2. `~/.config/hypr/themes/mirage.conf` / `light.conf` — the `$wallpaper` line
3. (nothing else — hyprlock reads `$wallpaper`)

Apply live without logout:
```bash
hyprctl hyprpaper wallpaper ",$HOME/.config/hypr/wallpapers/ayu-mirage.png"
```
Or just re-run the theme switch. If you changed `hyprpaper.conf` itself, restart
the daemon: `pkill hyprpaper; hyprpaper &`.

---

## 6. Common tweaks, quick reference

| Want to… | Edit | Apply |
|---|---|---|
| Rebind/add a shortcut | `hyprland.conf` (`bind = …` lines) | `hyprctl reload` |
| Change brightness step/floor | `hypr/scripts/brightness.sh` (`STEP/MIN/MAX`) | none |
| Change auto-lock timeout | `hypr/hypridle.conf` | `pkill hypridle; hypridle &` |
| Add a waybar module | `waybar/config.jsonc` + `style.css` | restart waybar |
| Change monitor/resolution | `hyprland.conf` (`monitor = …`) | `hyprctl reload` |
| Change keyboard layout | `hyprland.conf` (`input { kb_layout }`) | `hyprctl reload` |

**Useful commands:**
```bash
hyprctl reload              # reload Hyprland config
hyprctl configerrors        # verify config parses
hyprctl clients             # list windows (find a class for a windowrule)
hyprctl monitors            # list outputs
makoctl reload              # reload notifications
```

---

## 7. Saving changes to GitHub

The repo is `~/ayu-rice/` → **github.com/josemariasava/ayu-rice** (SSH remote).
Because the repo is a *copy*, the flow is: **sync → commit → push.**

### Step 1 — sync your live config into the repo
Copy only the files you changed, e.g.:
```bash
cp ~/.config/hypr/hyprland.conf   ~/ayu-rice/.config/hypr/hyprland.conf
cp ~/.config/waybar/style.css     ~/ayu-rice/.config/waybar/style.css
# …and any others you touched
```
> **Do NOT copy the "active" symlinks** (`theme.conf`, `waybar/colors.css`,
> `rofi/colors.rasi`, `mako/config`, `kitty/theme.conf`). The repo keeps those
> pointing at **mirage** as the shipped default; your live ones may point at
> light. Copy the real `*-mirage` / `*-light` files instead.

To see what actually drifted before copying:
```bash
for d in hypr waybar rofi mako kitty wlogout; do
  diff -rq --no-dereference ~/.config/$d ~/ayu-rice/.config/$d
done
```

### Step 2 — commit and push
```bash
cd ~/ayu-rice
git status            # review what changed
git add -A
git commit -m "Describe your change"
git push
```
That's it — refresh the GitHub page to see it. (This uses your SSH key; no
password/token needed. `gh` is not installed and isn't required.)

### Reinstalling on a fresh machine
```bash
git clone git@github.com:josemariasava/ayu-rice.git
cd ayu-rice && ./install.sh    # copies .config into ~/.config with timestamped backups
```
`install.sh` does **not** install apt packages — see `README.md` for the
dependency list and the hardware-specific lines to adjust (monitor, keyboard,
backlight device).

---

## 8. If something breaks

- **Hyprland won't apply a change / config error box at login:** run
  `hyprctl configerrors` — it names the offending line. Most 0.53 breakage is the
  old window/layer-rule syntax (see [§4](#4-changing-style-not-just-color)).
- **No icons in waybar (blank gaps):** a glyph got stripped to a space — re-add
  the real codepoint, confirm *JetBrainsMono Nerd Font* is installed
  (`fc-list | grep -i jetbrains`).
- **rofi shows a "variable failed to resolve" box:** a self-referential color
  var in `colors.rasi` — see [§3c](#3c-rofi-colors).
- **Screen too dark after brightness-down:** the wrapper clamps to 10% minimum;
  if you edited `brightness.sh`, check `MIN`.
- **Fall back to GNOME:** GNOME is kept as a selectable session at the login
  screen if Hyprland ever misbehaves.
