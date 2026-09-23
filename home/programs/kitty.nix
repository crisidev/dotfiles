{
  pkgs,
  config,
  ...
}:
let
  # kitty is GTK/GL and runs on this non-NixOS host, so wrap it with nixGL exactly
  # like ghostty (was `(nixGL pkgs.kitty)` in falcon's package list).
  nixGL = import ../nixGL.nix { inherit pkgs config; };
in
{
  programs.kitty = {
    enable = true;
    package = nixGL pkgs.kitty;

    # The old ~/.config/kitty/kitty.conf had no `shell_integration` line, so it used
    # kitty's built-in default. mode = null suppresses the line home-manager would
    # otherwise inject ("shell_integration no-rc"), preserving that behaviour.
    shellIntegration.mode = null;

    # Ported from the old homesick kitty.conf (readFile keeps the nerd-font
    # `tab_activity_symbol` glyph intact). The per-monitor font size lives in the
    # runtime-mutable ~/.config/kitty/font_size.conf (written by monitor-switch,
    # deliberately NOT nix-managed) and is pulled in via `globinclude`.
    extraConfig = builtins.readFile ../files/kitty/kitty.conf;
  };

  # Secondary config used by the `ide` script (`kitty --config .../ide.conf`).
  # The original did a relative `include kitty.conf`; under nix ide.conf and
  # kitty.conf live at different store paths, so the include is made absolute.
  xdg.configFile."kitty/ide.conf".text = ''
    # vim:fileencoding=utf-8:ft=conf
    include ~/.config/kitty/kitty.conf

    # Tab management
    map ctrl+right         no_op
    map ctrl+left          no_op
    map ctrl+super+right   no_op
    map ctrl+super+left    no_op
    map ctrl+t             no_op
    map ctrl+super+w       no_op
  '';
}
