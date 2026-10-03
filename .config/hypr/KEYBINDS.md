# Hyprland — Ayu rice cheat sheet   (Super = Windows key)

## Apps
| Keys | Action |
|------|--------|
| `Super + Return` | Terminal (kitty) |
| `Super + D` | App launcher (rofi) |
| `Super + E` | File manager (nautilus) |
| `Super + B` | Browser (brave) |
| `Super + C` | Clipboard history |
| `Super + Q` | Close window |
| `Super + L` | Lock screen |
| `Super + Shift + E` | Power menu (wlogout) |
| `Super + M` | Quit Hyprland → back to GDM |

## Floating & layout  ← what you asked for
| Keys | Action |
|------|--------|
| `Super + V` | Toggle window tiled ⇄ floating |
| `Super + Left-drag (mouse)` | **Move / float any window** |
| `Super + Right-drag (mouse)` | **Resize window** |
| drag window border | Resize (tiled) |
| `Super + F` | Fullscreen |
| `Super + J` | Toggle split direction |
| `Super + P` | Pseudo-tile |

## Focus & move
| Keys | Action |
|------|--------|
| `Super + ← ↑ → ↓` | Move focus |
| `Super + Shift + ← ↑ → ↓` | Move window |
| `Super + Ctrl + ← ↑ → ↓` | Resize window |

## Workspaces
| Keys | Action |
|------|--------|
| `Super + 1..0` | Go to workspace 1–10 |
| `Super + Shift + 1..0` | Send window to workspace |
| `Super + scroll` | Cycle workspaces |
| `Super + S` | Scratchpad (special workspace) |

## Theme
| Keys | Action |
|------|--------|
| `Super + Shift + T` | Toggle **Ayu Mirage ⇄ Ayu Light** |

## Screenshots
| Keys | Action |
|------|--------|
| `Print` | Whole screen → clipboard |
| `Super + Print` | Select region → clipboard |
| `Shift + Print` | Whole screen → ~/Pictures |

## Media / brightness
Volume, mute, brightness, and play/pause use the dedicated laptop keys.

---
Edit configs in `~/.config/hypr/`, `~/.config/waybar/`, `~/.config/rofi/`.
After editing `hyprland.conf`, apply with `hyprctl reload` (no logout needed).
