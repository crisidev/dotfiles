{ pkgs, ... }:
let
  # Nord palette mapped onto Qt's QPalette roles, so qt6ct's built-in Fusion style
  # renders host-native Qt apps dark + Nord — coherent with the GTK Orchis-*-Nord
  # theme. Fusion is built into Qt (no style plugin to fail to load), which is the
  # safe choice on this non-NixOS host. Colour order is QPalette::ColorRole 0..20:
  # WindowText Button Light Midlight Dark Mid Text BrightText ButtonText Base
  # Window Shadow Highlight HighlightedText Link LinkVisited AlternateBase NoRole
  # ToolTipBase ToolTipText PlaceholderText
  nordColorScheme = pkgs.writeText "qt6ct-nord.conf" ''
    [ColorScheme]
    active_colors=#ffd8dee9, #ff3b4252, #ff4c566a, #ff434c5e, #ff2e3440, #ff3b4252, #ffeceff4, #ffeceff4, #ffd8dee9, #ff3b4252, #ff2e3440, #ff232831, #ff5e81ac, #ffeceff4, #ff88c0d0, #ffb48ead, #ff434c5e, #ff2e3440, #ff3b4252, #ffd8dee9, #ff7b88a1
    disabled_colors=#ff5c667a, #ff353b49, #ff4c566a, #ff434c5e, #ff2e3440, #ff3b4252, #ff5c667a, #ffeceff4, #ff5c667a, #ff2e3440, #ff2e3440, #ff232831, #ff434c5e, #ff7b88a1, #ff5e81ac, #ffb48ead, #ff353b49, #ff2e3440, #ff3b4252, #ffd8dee9, #ff4c566a
    inactive_colors=#ffd8dee9, #ff3b4252, #ff4c566a, #ff434c5e, #ff2e3440, #ff3b4252, #ffeceff4, #ffeceff4, #ffd8dee9, #ff3b4252, #ff2e3440, #ff232831, #ff4c566a, #ffd8dee9, #ff88c0d0, #ffb48ead, #ff434c5e, #ff2e3440, #ff3b4252, #ffd8dee9, #ff7b88a1
  '';
in
{
  # qt6ct is already the platform theme (QT_QPA_PLATFORMTHEME=qt6ct is set in
  # hyprland.nix's env). Install it explicitly and configure it declaratively.
  home.packages = [ pkgs.kdePackages.qt6ct ];

  # qt6ct config. Fusion + the Nord palette above; icons/fonts mirror the GTK side
  # (Papirus-Dark, Inter, JetBrainsMono) so both toolkits read as one theme.
  # standard_dialogs=gtk3 routes Qt file dialogs through the GTK portal for a
  # matching look. home-manager makes this read-only, so tweak here, not in the GUI.
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    color_scheme_path=${nordColorScheme}
    custom_palette=true
    icon_theme=Papirus-Dark
    standard_dialogs=gtk3
    style=Fusion

    [Fonts]
    fixed="JetBrainsMono Nerd Font,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    general="Inter,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
  '';
}
