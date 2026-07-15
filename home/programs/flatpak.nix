{ ... }:
{
  # Flatpak per-app overrides + the Signal launcher override, ported byte-for-byte
  # from home/.local/share/flatpak/overrides and .local/share/applications.
  # There's no home-manager module for flatpak overrides, so they're placed as
  # data files. home-manager makes them read-only, so edit the sources here rather
  # than via `flatpak override`.
  #
  # CRITIQUE (functional config unchanged, but the rationales are dated):
  #   - global sets ICON_THEME=Suru++ for flatpaks while the host GTK now uses
  #     Papirus-Dark (hyprland.nix) — a deliberate-or-not icon mismatch.
  #   - global's GTK_THEME=Orchis-Grey-Dark-Nord duplicates the value defined in
  #     hyprland.nix; keep them in sync by hand.
  #   - Signal + Spotify are forced onto XWayland for reasons that were about
  #     pop-shell / GNOME's Mutter (the comments in those files) — both dead under
  #     Hyprland. They could likely move to native Wayland (like Ferdium) and drop
  #     the X11 + nixGL-driver workarounds. Left as-is here; flip when you want.
  xdg.dataFile = {
    "flatpak/overrides/global".source = ../files/flatpak/overrides/global;
    "flatpak/overrides/org.signal.Signal".source = ../files/flatpak/overrides/org.signal.Signal;
    "flatpak/overrides/com.spotify.Client".source = ../files/flatpak/overrides/com.spotify.Client;
    "flatpak/overrides/org.ferdium.Ferdium".source = ../files/flatpak/overrides/org.ferdium.Ferdium;

    # Overrides the flatpak-exported Signal launcher (must live in
    # ~/.local/share/applications to win precedence) with the XWayland Exec.
    "applications/org.signal.Signal.desktop".source = ../files/applications/org.signal.Signal.desktop;
  };
}
