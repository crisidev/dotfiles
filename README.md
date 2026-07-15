# 🤟 Crisidev Dotfiles 🤟

Take what you need, it also comes warrant free 😊

* [Look and feel](#look-and-feel)
* [Installation](#installation)
* [Hyprland](#hyprland)

## Look and feel

![Desktop](desktop.png)

## Installation

```sh
❯❯❯ git clone https://github.com/crisidev/dotfiles.git $HOME/.config/home-manager
❯❯❯ cd $HOME/.config/home-manager
❯❯❯ ./home-manager switch
```

## Hyprland

Hyprland is configured as an optional Wayland session alongside GNOME. It uses the
[Hyprland flake](https://github.com/hyprwm/Hyprland) wrapped with nixGL for non-NixOS systems,
and is themed with [TokyoNight Night](https://github.com/folke/tokyonight.nvim).

**Stack:** Hyprland · Waybar · Wofi · Mako · Hyprlock · Hypridle · swww · wlsunset

### 1. Apply home-manager

```sh
cd ~/.homesick/repos/dotfiles
home-manager switch --flake .#falcon
```

### 2. Register the GDM session

GDM only reads `/usr/share/wayland-sessions/`, which home-manager can't write to
as your user. A home-manager activation script (`installHyprlandSession` in
`falcon.nix`) copies the generated `hyprland.desktop` there **as root** on every
`switch`, but only when the file actually changed (guarded by `cmp`), and also
removes the stale `hyprland-nix.desktop`.

Activation has no TTY, so it can't prompt for a sudo password — it uses `sudo -n`
and relies on a one-time scoped **NOPASSWD** rule. Install it once (the rule text
is generated at `~/.config/hyprland/gdm-session.sudoers`, so it always matches the
exact commands the script runs):

```sh
sudo install -m440 -o root -g root \
  ~/.config/hyprland/gdm-session.sudoers /etc/sudoers.d/50-hyprland-gdm-session
sudo visudo -c    # sanity-check syntax
```

After that, every `home-manager switch` keeps the GDM session in sync silently.
Until it's installed, the switch prints a NOTE with these same commands; you can
also just register the session by hand once:

```sh
sudo install -m644 ~/.local/share/wayland-sessions/hyprland.desktop \
  /usr/share/wayland-sessions/hyprland.desktop
sudo rm -f /usr/share/wayland-sessions/hyprland-nix.desktop
```

The `.desktop`'s `Exec` runs `start-hyprland` (the official launcher) rather than
the `Hyprland` binary directly — launching Hyprland directly triggers a "launched
without start-hyprland" warning at startup. It passes an absolute
`--path …/Hyprland` (plus `--no-nixgl`) on purpose: `start-hyprland` otherwise
finds the compositor with a bare-name `execvp("Hyprland")`, and GDM's session
`PATH` has no `~/.nix-profile/bin`, so that lookup fails ("fork(): execvp
failed") and GDM bounces you back to the login screen. The absolute path skips
the lookup; `--no-nixgl` is right because that target is already the nixGL
wrapper.

Log out, select **Hyprland** from the GDM session menu, and log in.

### Keybindings

Keybindings mirror the existing GNOME/pop-shell layout from `home/.bin/gsettings-update`.

| Key | Action |
|-----|--------|
| `Super+Return` | Terminal (kitty) |
| `Super+Space` | App launcher (wofi) |
| `Super+W` | Close window |
| `Super+F` | Toggle maximized |
| `Super+Tab` / `Alt+Tab` | Window switcher |
| `Super+Escape` | Workspace 1 |
| `Super+F1/F2/F3` | Workspaces 2–4 |
| `Super+1..4` | Workspaces 5–8 |
| `Super+Shift+...` | Move window to workspace |
| `Super+Alt+arrows` | Move window to adjacent tile |
| `Super+arrows` | Move focus |
| `Super+Alt+Backspace` | Enter resize mode (arrows resize, Esc exits) |
| `Super+Alt+L` | Lock screen |
| `Super+Alt+K` | Suspend |
| `Super+Alt+E` | Exit Hyprland |
| `Super+Alt+P` | 1Password quick access |
| `Super+Alt+D` | Switch monitor layout |
| `Shift+Print` | Screenshot region |
| `Alt+Print` | Screenshot active window |
| `Ctrl+Space` | Nautilus |
| `Super+Z` | IDE |

### System controls

Everything accessible from the Waybar at the top:

| Control | How |
|---------|-----|
| Network | Click wifi icon → nm-connection-editor |
| Bluetooth | Click BT icon → blueman |
| Audio | Click volume icon → pavucontrol |
| Brightness | Scroll on backlight icon |
| Color temperature | Click moon icon → toggle wlsunset |
| USB / removable | udiskie system tray icon |
| Monitor layout | `Super+Alt+D` or run `nwg-displays` |
