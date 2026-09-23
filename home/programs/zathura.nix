{ config, ... }:
let
  inherit (config.theme.palette) rgba;
  c = config.theme.palette.colors;
in
{
  programs.zathura = {
    enable = true;
    # Tokyo Night Storm from the shared palette (home/theme). recolor maps page
    # white → bg and black → fg, so PDFs read as dark pages; toggle with ^R.
    options = {
      default-bg = c.bg;
      default-fg = c.fg;
      statusbar-bg = c.bgDark;
      statusbar-fg = c.fgDark;
      inputbar-bg = c.bgDark;
      inputbar-fg = c.fg;
      notification-bg = c.bgDark;
      notification-fg = c.fg;
      notification-error-bg = c.bgDark;
      notification-error-fg = c.red;
      notification-warning-bg = c.bgDark;
      notification-warning-fg = c.yellow;
      completion-bg = c.bgDark;
      completion-fg = c.fg;
      completion-highlight-bg = c.bgVisual;
      completion-highlight-fg = c.fg;
      index-bg = c.bg;
      index-fg = c.fg;
      index-active-bg = c.bgVisual;
      index-active-fg = c.fg;
      highlight-color = rgba c.yellow 0.4;
      highlight-active-color = rgba c.blue 0.4;
      recolor = true;
      recolor-lightcolor = c.bg;
      recolor-darkcolor = c.fg;
    };
    extraConfig = ''
      set adjust-open "best-fit"
      set selection-clipboard clipboard
    '';
  };
}
