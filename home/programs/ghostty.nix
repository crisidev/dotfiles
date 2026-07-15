{
  pkgs,
  config,
  ...
}:
let
  # Wrap with nixGL for OpenGL on this non-NixOS host, like kitty/hyprland
  # (was `(nixGL pkgs.ghostty)` in falcon's package list).
  nixGL = import ../nixGL.nix { inherit pkgs config; };
in
{
  # ghostty — ported 1:1 from home/.config/ghostty/config.
  programs.ghostty = {
    enable = true;
    package = nixGL pkgs.ghostty;
    # Shell integration comes from ghostty's own `shell-integration = zsh` below;
    # don't also inject home-manager's zsh hook (programs.zsh is enabled).
    enableZshIntegration = false;

    settings = {
      font-family = "MonoLisa Nerd Font";
      font-family-bold = "MonoLisa Nerd Font";
      font-family-italic = "MonoLisa Nerd Font";
      font-family-bold-italic = "MonoLisa Nerd Font";
      font-size = 13;

      theme = "tokyonight-storm";
      background-opacity = 0.95;
      gtk-titlebar = false;
      window-theme = "ghostty";

      keybind = [
        "ctrl+super+v=paste_from_clipboard"
        "super+/=paste_from_selection"
        "ctrl+super+c=copy_to_clipboard"
        "ctrl+t=new_tab"
        "ctrl+right=next_tab"
        "ctrl+left=previous_tab"
        "ctrl+super+right=move_tab:+1"
        "ctrl+super+left=move_tab:-1"
        "ctrl+super+w=close_surface"
        "shift+up=scroll_page_lines:+1"
        "shift+down=scroll_page_lines:-1"
        "shift+page_up=scroll_page_up"
        "shift+page_down=scroll_page_down"
        "ctrl+super+equal=increase_font_size:1"
        "ctrl+super+minus=decrease_font_size:1"
        "ctrl+super+backspace=reset_font_size"
        "ctrl+super+f=write_scrollback_file:open"
      ];

      shell-integration-features = "cursor, sudo, title";
      shell-integration = "zsh";
    };
  };
}
