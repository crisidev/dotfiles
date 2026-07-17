{ ... }:
{
  # Flatpak per-app overrides + the Spotify launcher override, ported from
  # home/.local/share/flatpak/overrides and .local/share/applications. There's no
  # home-manager module for flatpak overrides, so they're placed as data files.
  # home-manager makes them read-only, so edit the sources here rather than via
  # `flatpak override`.
  #
  # Signal + Spotify now run on native Wayland (were XWayland for dead pop-shell /
  # GNOME-Mutter reasons — see the per-app override comments). On the 1.2 monitor
  # scale, XWayland surfaces were bitmap-upscaled → grainy text; native Wayland
  # renders at the fractional scale, sharp. Signal (Electron) needs only the
  # wayland socket + ELECTRON_OZONE_PLATFORM_HINT=auto, so it drops its custom
  # launcher and uses the stock export (like Ferdium). Spotify (CEF) has no ozone
  # env var, so it keeps a custom launcher that passes --ozone-platform-hint=auto.
  #
  # CRITIQUE (functional config unchanged, but the rationales are dated):
  #   - global sets ICON_THEME=Suru++ for flatpaks while the host GTK now uses
  #     Papirus-Dark (hyprland.nix) — a deliberate-or-not icon mismatch.
  #   - global's GTK_THEME=Orchis-Grey-Dark-Nord duplicates the value defined in
  #     hyprland.nix; keep them in sync by hand.
  xdg.dataFile = {
    "flatpak/overrides/global".source = ../files/flatpak/overrides/global;
    "flatpak/overrides/org.signal.Signal".source = ../files/flatpak/overrides/org.signal.Signal;
    "flatpak/overrides/com.spotify.Client".source = ../files/flatpak/overrides/com.spotify.Client;
    "flatpak/overrides/org.ferdium.Ferdium".source = ../files/flatpak/overrides/org.ferdium.Ferdium;

    # Overrides the flatpak-exported Spotify launcher (must live in
    # ~/.local/share/applications to win precedence) to add the ozone Wayland flag.
    "applications/com.spotify.Client.desktop".source = ../files/applications/com.spotify.Client.desktop;
  };
}
