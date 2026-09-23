{ pkgs, lib, ... }:
let
  # Firefox (flatpak) keeps tabs in the titlebar, so its window buttons are
  # its own widgets, not a GTK headerbar — the GTK theme alone doesn't restyle
  # them (the non-native-buttons pref below didn't either). userChrome.css
  # draws them as the Orchis-Grey-Dark-Nord macos traffic lights instead:
  # 16px circles, Nord red/yellow/green, translucent grey when unfocused.
  firefoxUserJs = pkgs.writeText "firefox-user.js" ''
    user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
    user_pref("widget.gtk.non-native-titlebar-buttons.enabled", false);
  '';

  firefoxUserChrome = pkgs.writeText "firefox-userChrome.css" ''
    /* macOS-style traffic lights, colours from Orchis-Grey-Dark-Nord (macos). */
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
    .titlebar-close > .toolbarbutton-icon { background-color: #bf616a !important; }
    .titlebar-min > .toolbarbutton-icon { background-color: #ebcb8b !important; }
    .titlebar-max > .toolbarbutton-icon,
    .titlebar-restore > .toolbarbutton-icon { background-color: #a3be8c !important; }
    .titlebar-close:active > .toolbarbutton-icon { background-color: #cf898f !important; }
    .titlebar-min:active > .toolbarbutton-icon { background-color: #f0d8a8 !important; }
    .titlebar-max:active > .toolbarbutton-icon,
    .titlebar-restore:active > .toolbarbutton-icon { background-color: #bacea9 !important; }
    .titlebar-button:hover > .toolbarbutton-icon { filter: brightness(1.12); }
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
  # Flatpaks read the theme from ~/.themes (global override), which is the
  # hand-installed Orchis-Grey-Dark-Nord macos build — the sandbox can't follow
  # symlinks into /nix/store, so the nix-built copy in gnome.nix isn't visible
  # to it.
  #
  # CRITIQUE (functional config unchanged, but the rationales are dated):
  #   - global sets ICON_THEME=Suru++ for flatpaks while the host GTK now uses
  #     Papirus-Dark (gnome.nix) — a deliberate-or-not icon mismatch.
  #   - global's GTK_THEME=Orchis-Grey-Dark-Nord duplicates the value defined in
  #     gnome.nix; keep them in sync by hand.
  xdg.dataFile = {
    "flatpak/overrides/global".source = ../files/flatpak/overrides/global;
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
}
