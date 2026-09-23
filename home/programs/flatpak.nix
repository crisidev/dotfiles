{ pkgs, lib, ... }:
let
  # Firefox (flatpak) prefs. Firefox draws its own Adwaita-style titlebar
  # buttons by default; turning that off makes it use the GTK theme's (Orchis
  # macos) buttons like every other app.
  firefoxUserJs = pkgs.writeText "firefox-user.js" ''
    user_pref("widget.gtk.non-native-titlebar-buttons.enabled", false);
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

  # The sandbox can't follow a symlink into /nix/store, so install user.js as a
  # real file into the default profile (resolved from installs.ini at switch
  # time, so a new profile is picked up without editing this).
  home.activation.firefoxUserJs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ffdir="$HOME/.var/app/org.mozilla.firefox/config/mozilla/firefox"
    profile=$(${pkgs.gnused}/bin/sed -n 's/^Default=//p' "$ffdir/installs.ini" 2>/dev/null | head -1)
    if [ -n "$profile" ] && [ -d "$ffdir/$profile" ]; then
      run install -m644 ${firefoxUserJs} "$ffdir/$profile/user.js"
    fi
  '';
}
