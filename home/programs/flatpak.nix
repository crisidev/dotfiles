{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config) theme;
  c = theme.palette.colors;

  # Firefox (flatpak) keeps tabs in the titlebar, so its window buttons are
  # its own widgets, not a GTK headerbar — the GTK theme alone doesn't restyle
  # them (the non-native-buttons pref below didn't either). userChrome.css
  # draws them as the Orchis macos traffic lights instead: 16px circles in the
  # palette's red/yellow/green, translucent grey when unfocused.
  firefoxUserJs = pkgs.writeText "firefox-user.js" ''
    user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
    user_pref("widget.gtk.non-native-titlebar-buttons.enabled", false);
  '';

  firefoxUserChrome = pkgs.writeText "firefox-userChrome.css" ''
    /* macOS-style traffic lights, colours from the Tokyo Night palette. */
    .titlebar-buttonbox {
      align-items: center !important;
      margin-inline: 8px !important;
    }
    .titlebar-button {
      appearance: none !important;
      background: none !important;
      padding: 0 4px !important;
      margin: 0 !important;
    }
    .titlebar-button > .toolbarbutton-icon {
      appearance: none !important;
      list-style-image: none !important;
      background-image: none !important;
      width: 16px !important;
      height: 16px !important;
      min-width: 16px !important;
      padding: 0 !important;
      border-radius: 50% !important;
    }
    .titlebar-close > .toolbarbutton-icon { background-color: ${c.red} !important; }
    .titlebar-min > .toolbarbutton-icon { background-color: ${c.yellow} !important; }
    .titlebar-max > .toolbarbutton-icon,
    .titlebar-restore > .toolbarbutton-icon { background-color: ${c.green} !important; }
    .titlebar-button:hover > .toolbarbutton-icon { filter: brightness(1.12); }
    .titlebar-button:active > .toolbarbutton-icon { filter: brightness(1.25); }
    :root:-moz-window-inactive .titlebar-button > .toolbarbutton-icon {
      background-color: rgba(255, 255, 255, 0.3) !important;
    }
  '';
in
{
  # Flatpak per-app overrides, ported from home/.local/share/flatpak/overrides.
  # There's no home-manager module for flatpak overrides, so they're placed as
  # data files. home-manager makes them read-only, so edit the sources here
  # rather than via `flatpak override`.
  #
  # Ferdium, Signal and Spotify are kept on XWayland (see the per-app override
  # comments): mutter-x11-frames then draws their titlebars with the Orchis
  # macos buttons and there's no CSD gap to pop-shell's border.
  #
  # Flatpaks read the GTK and icon themes from ~/.themes and ~/.icons (global
  # override). The sandbox can't follow symlinks into /nix/store, so the
  # flatpakThemes activation below copies the nix-built config.theme ones there
  # as real files, and the override names them from the same config.theme.
  xdg.dataFile = {
    "flatpak/overrides/global".text = ''
      [Context]
      filesystems=xdg-config/gtk-3.0:ro;~/.local/share/icons:ro;xdg-config/gtk-4.0:ro;~/.themes:ro;~/.icons:ro;

      [Environment]
      GTK_THEME=${theme.gtk.name}
      ICON_THEME=${theme.icons.name}
      XCURSOR_THEME=${theme.cursor.name}
      ELECTRON_OZONE_PLATFORM_HINT=auto
    '';
    "flatpak/overrides/org.signal.Signal".source = ../files/flatpak/overrides/org.signal.Signal;
    "flatpak/overrides/com.spotify.Client".source = ../files/flatpak/overrides/com.spotify.Client;
    "flatpak/overrides/org.ferdium.Ferdium".source = ../files/flatpak/overrides/org.ferdium.Ferdium;

    # Launchers passing --ozone-platform=x11 (Electron ignores the env hint).
    # They live in ~/.local/share/applications, so they shadow the flatpak
    # exports in the dash; gnome.nix autostarts these same files.
    "applications/org.ferdium.Ferdium.desktop".source =
      ../files/applications/org.ferdium.Ferdium.desktop;
    "applications/org.signal.Signal.desktop".source = ../files/applications/org.signal.Signal.desktop;
  };

  # The sandbox can't follow a symlink into /nix/store, so install user.js and
  # userChrome.css as real files into the default profile (resolved from installs.ini at switch
  # time, so a new profile is picked up without editing this).
  # Firefox uses the legacy ~/.mozilla root whenever it exists and only falls
  # back to the XDG one (config/mozilla) otherwise — pick the same.
  home.activation.firefoxUserJs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ffapp="$HOME/.var/app/org.mozilla.firefox"
    if [ -d "$ffapp/.mozilla/firefox" ]; then
      ffdir="$ffapp/.mozilla/firefox"
    else
      ffdir="$ffapp/config/mozilla/firefox"
    fi
    profile=$(${pkgs.gnused}/bin/sed -n 's/^Default=//p' "$ffdir/installs.ini" 2>/dev/null | head -1)
    if [ -n "$profile" ] && [ -d "$ffdir/$profile" ]; then
      run install -m644 ${firefoxUserJs} "$ffdir/$profile/user.js"
      run install -D -m644 ${firefoxUserChrome} "$ffdir/$profile/chrome/userChrome.css"
    fi
  '';

  # Real-file copies of the GTK theme and icon themes for flatpaks, re-copied
  # only when the store path changes (a .nix-src stamp records it). The Tela
  # -dark/-light variants link (relatively) into the base Tela-tokyonight-blue,
  # so the whole icon set is copied.
  home.activation.flatpakThemes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    copyTheme() {
      src="$1"; dst="$2"
      if [ "$(cat "$dst/.nix-src" 2>/dev/null)" != "$src" ]; then
        run rm -rf "$dst"
        run mkdir -p "$(dirname "$dst")"
        run cp -a --no-preserve=mode,ownership "$src" "$dst"
        if [ -z "''${DRY_RUN:-}" ]; then echo "$src" > "$dst/.nix-src"; fi
      fi
    }
    copyTheme ${theme.gtk.package}/share/themes/${theme.gtk.name} "$HOME/.themes/${theme.gtk.name}"
    for d in ${theme.icons.package}/share/icons/Tela-tokyonight-*; do
      copyTheme "$d" "$HOME/.icons/$(basename "$d")"
    done
  '';
}
