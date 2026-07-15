{ ... }:
{
  # yazi — ported 1:1 from home/.config/yazi/yazi.toml. The settings attrset is
  # generated from the original TOML so the powerline separator glyphs survive
  # byte-for-byte; home-manager renders it back to ~/.config/yazi/yazi.toml.
  programs.yazi = {
    enable = true;
    # Shell integration (auto-enabled once programs.zsh is on) adds a wrapper that
    # cd's to yazi's last directory on quit. Pin the name explicitly to the new
    # forward default ("y") — silences the stateVersion<26.05 "yy" legacy warning.
    shellWrapperName = "y";
    settings = {
      log = {
        enabled = false;
      };
      mgr = {
        show_hidden = true;
        show_symlink = true;
        sort_dir_first = true;
        sort_reverse = true;
        cwd = {
          fg = "#a9b1d6";
          italic = true;
        };
        hovered = {
          bg = "#292e42";
        };
        preview_hovered = {
          bg = "#292e42";
        };
        find_keyword = {
          fg = "#1f2335";
          bg = "#ff9e64";
          bold = true;
        };
        find_position = {
          fg = "#0db9d7";
          bg = "#22374b";
          bold = true;
        };
        marker_copied = {
          fg = "#73daca";
          bg = "#73daca";
        };
        marker_cut = {
          fg = "#f7768e";
          bg = "#f7768e";
        };
        marker_marked = {
          fg = "#bb9af7";
          bg = "#bb9af7";
        };
        marker_selected = {
          fg = "#7aa2f7";
          bg = "#7aa2f7";
        };
        tab_active = {
          fg = "#c0caf5";
          bg = "#292e42";
        };
        tab_inactive = {
          fg = "#3b4261";
          bg = "#24283b";
        };
        tab_width = 1;
        count_copied = {
          fg = "#c0caf5";
          bg = "#41a6b5";
        };
        count_cut = {
          fg = "#c0caf5";
          bg = "#db4b4b";
        };
        count_selected = {
          fg = "#c0caf5";
          bg = "#3d59a1";
        };
        border_symbol = "│";
        border_style = {
          fg = "#29a4bd";
        };
      };
      status = {
        separator_open = "";
        separator_close = "";
        separator_style = {
          fg = "#3b4261";
          bg = "#3b4261";
        };
        mode_normal = {
          fg = "#1f2335";
          bg = "#7aa2f7";
          bold = true;
        };
        mode_select = {
          fg = "#1f2335";
          bg = "#bb9af7";
          bold = true;
        };
        mode_unset = {
          fg = "#1f2335";
          bg = "#9d7cd8";
          bold = true;
        };
        progress_label = {
          fg = "#a9b1d6";
          bold = true;
        };
        progress_normal = {
          fg = "#24283b";
        };
        progress_error = {
          fg = "#f7768e";
        };
        permissions_t = {
          fg = "#7aa2f7";
        };
        permissions_r = {
          fg = "#e0af68";
        };
        permissions_w = {
          fg = "#f7768e";
        };
        permissions_x = {
          fg = "#9ece6a";
        };
        permissions_s = {
          fg = "#414868";
        };
      };
      select = {
        border = {
          fg = "#29a4bd";
        };
        active = {
          fg = "#c0caf5";
          bg = "#2e3c64";
        };
        inactive = {
          fg = "#c0caf5";
        };
      };
      input = {
        border = {
          fg = "#0db9d7";
        };
        title = { };
        value = {
          fg = "#9d7cd8";
        };
        selected = {
          bg = "#2e3c64";
        };
      };
      completion = {
        border = {
          fg = "#0db9d7";
        };
        active = {
          fg = "#c0caf5";
          bg = "#2e3c64";
        };
        inactive = {
          fg = "#c0caf5";
        };
      };
      tasks = {
        border = {
          fg = "#29a4bd";
        };
        title = { };
        hovered = {
          fg = "#c0caf5";
          bg = "#2e3c64";
        };
      };
      which = {
        cols = 3;
        mask = {
          bg = "#1f2335";
        };
        cand = {
          fg = "#7dcfff";
        };
        rest = {
          fg = "#7aa2f7";
        };
        desc = {
          fg = "#bb9af7";
        };
        separator = "  ";
        separator_style = {
          fg = "#565f89";
        };
      };
      notify = {
        title_info = {
          fg = "#0db9d7";
        };
        title_warn = {
          fg = "#e0af68";
        };
        title_error = {
          fg = "#f7768e";
        };
      };
      help = {
        on = {
          fg = "#9ece6a";
        };
        run = {
          fg = "#bb9af7";
        };
        hovered = {
          bg = "#2e3c64";
        };
        footer = {
          fg = "#c0caf5";
          bg = "#24283b";
        };
      };
      filetype = {
        rules = [
          {
            mime = "image/*";
            fg = "#e0af68";
          }
          {
            mime = "{audio,video}/*";
            fg = "#bb9af7";
          }
          {
            mime = "application/*zip";
            fg = "#f7768e";
          }
          {
            mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}";
            fg = "#f7768e";
          }
          {
            mime = "application/{pdf,doc,rtf,vnd.*}";
            fg = "#7dcfff";
          }
          {
            name = "*";
            is = "orphan";
            bg = "#f7768e";
          }
          {
            name = "*";
            is = "exec";
            fg = "#9ece6a";
          }
          {
            name = "*/";
            fg = "#7aa2f7";
          }
        ];
      };
      opener = {
        open = [
          {
            desc = "Open";
            orphan = true;
            run = "xdg-open \"$@\"
";
          }
        ];
      };
    };
  };
}
