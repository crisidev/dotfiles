# Vicinae: Raycast-style launcher (apps, clipboard history, emoji, calculator,
# windows), themed from the palette as one more island. Mutter has no
# layer-shell, so it is a plain Qt window; its GNOME extension (linked and
# enabled in gnome.nix) supplies clipboard history, the window list, and
# centred, always-on-top, close-on-blur placement. Shortcuts are GNOME custom
# keybindings in gnome.nix: Vicinae's own global shortcuts don't work on GNOME.
{
  pkgs,
  lib,
  config,
  ...
}:
let
  nixGL = import ../nixGL.nix { inherit pkgs config; };
  inherit (config) theme;
  inherit (theme) island;
  c = theme.palette.colors;

  # "#7aa2f7" 0.6 → "#997aa2f7" (Vicinae themes take #AARRGGBB).
  alpha =
    col: a:
    "#${
      lib.fixedWidthString 2 "0" (lib.toHexString (builtins.floor (a * 255 + 0.5)))
    }${lib.removePrefix "#" col}";

  islandBorder = alpha island.borderColour island.borderAlpha;

  themeName = "tokyonight-dotfiles"; # not the bundled tokyo-night-storm: ours follows palette.nix
in
{
  programs.vicinae = {
    enable = true;
    # Qt Quick renders through GL: wrapped with nixGL like kitty (its server
    # inherits the wrapper's environment).
    package = nixGL pkgs.vicinae;
    systemd.enable = true;
    enableFirefoxIntegration = false; # Firefox is a flatpak

    themes.${themeName} = {
      meta = {
        version = 1;
        name = "Tokyo Night (dotfiles)";
        description = "Tokyo Night Storm from home/theme/palette.nix";
        variant = "dark";
      };
      colors = {
        core = {
          accent = c.blue;
          accent_foreground = c.bgDark;
          background = c.bgDark;
          foreground = c.fg;
          secondary_background = c.bg;
          border = c.fgGutter;
        };
        main_window = {
          border = islandBorder;
          footer.background = c.bgDarker;
        };
        settings_window.border = islandBorder;
        accents = {
          inherit (c)
            blue
            green
            magenta
            orange
            red
            yellow
            cyan
            purple
            ;
        };
        shortcut.border = c.fgGutter;
        text = {
          default = c.fg;
          muted = c.dark5;
          danger = c.red;
          success = c.green;
          placeholder = c.comment;
          selection = {
            background = c.bgVisual;
            foreground = c.fg;
          };
          links = {
            default = c.blue;
            visited = c.magenta;
          };
        };
        input = {
          border = c.fgGutter;
          border_focus = c.blue;
          border_error = c.red;
        };
        button.primary = {
          background = c.blue0;
          foreground = c.fg;
          hover.background = c.blue;
          focus.outline = c.blue;
        };
        list.item = {
          hover.foreground = c.fg;
          selection = {
            background = c.bgVisual;
            foreground = c.fg;
            secondary_background = c.bgHighlight;
            secondary_foreground = c.fgDark;
          };
        };
        grid.item = {
          background = c.bg;
          hover.outline = alpha c.blue 0.4;
          selection.outline = c.blue;
        };
        scrollbars.background = c.fgGutter;
        loading = {
          bar = c.blue;
          spinner = c.blue;
        };
      };
    };

    # Read-only (a store symlink): changes go through here, not the GUI.
    settings = {
      telemetry.system_info = false;
      # /dev/uinput is root-only on this host; without it Vicinae copies
      # instead of pasting into the focused window.
      input_server.enabled = false;
      tray.enabled = false;
      theme =
        lib.genAttrs
          [
            "dark"
            "light"
          ]
          (_: {
            name = themeName;
            icon_theme = theme.icons.name;
          });
      font.normal.family = "Inter";
      close_on_focus_loss = true;
      pop_to_root_on_close = true;
      launcher_window = {
        # Nothing blurs behind it on Mutter: as opaque as the shell popups.
        opacity = 0.92;
        material = "none";
        rounding = island.radius;
        client_side_decorations = {
          enabled = true;
          border_width = island.borderWidth;
        };
      };
    };
  };
}
