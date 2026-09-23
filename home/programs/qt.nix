{ pkgs, config, ... }:
let
  inherit (config) theme;
  inherit (theme.palette) argb;
  c = theme.palette.colors;

  # One qt6ct colour row, in QPalette::ColorRole order 0..20.
  row =
    roles:
    builtins.concatStringsSep ", " (
      map (r: argb roles.${r}) [
        "windowText"
        "button"
        "light"
        "midlight"
        "dark"
        "mid"
        "text"
        "brightText"
        "buttonText"
        "base"
        "window"
        "shadow"
        "highlight"
        "highlightedText"
        "link"
        "linkVisited"
        "alternateBase"
        "noRole"
        "toolTipBase"
        "toolTipText"
        "placeholderText"
      ]
    );

  active = {
    windowText = c.fg;
    button = c.bgHighlight;
    light = c.terminalBlack;
    midlight = c.fgGutter;
    dark = c.bgDarker;
    mid = c.bgHighlight;
    text = c.fg;
    brightText = "#ffffff";
    buttonText = c.fg;
    base = c.bgDark;
    window = c.bg;
    shadow = "#16161e";
    highlight = c.blue0;
    highlightedText = c.fg;
    link = c.blue;
    linkVisited = c.magenta;
    alternateBase = c.bgHighlight;
    noRole = c.bg;
    toolTipBase = c.bgDark;
    toolTipText = c.fg;
    placeholderText = c.comment;
  };

  inactive = active // {
    highlight = c.bgVisual;
  };

  disabled = active // {
    windowText = c.dark3;
    button = c.bgDark;
    text = c.dark3;
    buttonText = c.dark3;
    base = c.bg;
    highlight = c.bgHighlight;
    highlightedText = c.dark5;
    placeholderText = c.fgGutter;
  };

  # Tokyo Night mapped onto Qt's QPalette roles, so qt6ct's built-in Fusion style
  # renders host-native Qt apps in the same palette as the GTK Orchis-Tokyonight
  # theme. Fusion is built into Qt (no style plugin to fail to load), which is the
  # safe choice on this non-NixOS host.
  tokyonightColorScheme = pkgs.writeText "qt6ct-tokyonight.conf" ''
    [ColorScheme]
    active_colors=${row active}
    disabled_colors=${row disabled}
    inactive_colors=${row inactive}
  '';
in
{
  # qt6ct is the platform theme (QT_QPA_PLATFORMTHEME=qt6ct is exported to the
  # session via environment.d in gnome.nix). Install it and configure it declaratively.
  home.packages = [ pkgs.kdePackages.qt6ct ];

  # qt6ct config. Fusion + the palette above; icons/fonts mirror the GTK side
  # (config.theme icons, Inter, JetBrainsMono) so both toolkits read as one theme.
  # standard_dialogs=gtk3 routes Qt file dialogs through the GTK portal for a
  # matching look. home-manager makes this read-only, so tweak here, not in the GUI.
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    color_scheme_path=${tokyonightColorScheme}
    custom_palette=true
    icon_theme=${theme.icons.name}
    standard_dialogs=gtk3
    style=Fusion

    [Fonts]
    fixed="JetBrains Mono,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    general="Inter,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
  '';
}
