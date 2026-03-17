{
  pkgs,
  config,
  inputs,
  ...
}:
let
  nixGL = import ../nixGL.nix { inherit pkgs config; };
in
{
  # ── Core compositor ───────────────────────────────────────────────────────
  wayland.windowManager.hyprland = {
    enable = true;
    package = nixGL inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;

    plugins = [ ];

    settings = {
      monitor = ",preferred,auto,1";

      env = [
        "XCURSOR_THEME,Bibata-Modern-Ice"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "GTK_THEME,Tokyo Night Dark"
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "MOZ_ENABLE_WAYLAND,1"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        mouse_refocus = false; # focus-change-on-pointer-rest false
        touchpad = {
          natural_scroll = false;
          two_finger_scroll_speed = 1;
        };
        repeat_rate = 71; # ~gsettings repeat-interval 14ms → ~71/s
        repeat_delay = 230; # gsettings delay 230
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "rgba(7aa2f7ee) rgba(bb9af7ee) 45deg";
        "col.inactive_border" = "rgba(3b426166)";
        layout = "master";
        resize_on_border = true;
        allow_tearing = false;
      };

      master = {
        mfact = 0.618; # golden ratio
        new_status = "slave"; # new windows go to stack
        new_on_top = false;
        orientation = "left"; # master on the left
        inherit_fullscreen = true;
        smart_resizing = true;
      };

      decoration = {
        rounding = 12;
        rounding_power = 2.4; # 1. squircle corners — macOS-like
        active_opacity = 1.0;
        inactive_opacity = 0.92;
        dim_inactive = true;
        dim_strength = 0.05; # subtle depth separation
        blur = {
          enabled = true;
          size = 4; # 2. tighter blur — crisper frosted glass
          passes = 3;
          new_optimizations = true;
          noise = 0.02;
          contrast = 0.9;
          brightness = 0.75; # 2. slightly dimmer for depth
          vibrancy = 0.5; # 2. macOS-like vibrancy
          vibrancy_darkness = 1.0;
        };
        shadow = {
          enabled = true;
          range = 30;
          render_power = 3;
          color = "rgba(1a1b26dd)";
          color_inactive = "rgba(1a1b2688)";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "linear, 0.0, 0.0, 1.0, 1.0"
          "overshot, 0.7, 0.6, 0.1, 1.1"
        ];
        animation = [
          "windows, 1, 5, wind, slide"
          "windowsIn, 1, 5, winIn, slide"
          "windowsOut, 1, 4, winOut, popin 80%"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, linear"
          "borderangle, 1, 30, linear, loop"
          "fade, 1, 5, overshot"
          "workspaces, 1, 5, wind"
          "specialWorkspace, 1, 6, wind, slidevert"
        ];
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        vfr = true;
      };

      # Layer blur — frosted glass on waybar, wofi, mako
      layerrule = [
        "blur, waybar"
        "ignorezero, waybar"
        "blur, wofi"
        "ignorezero, wofi"
        "blur, mako"
        "ignorezero, mako"
        "blur, gtk-layer-shell"
        "ignorezero, gtk-layer-shell"
      ];

      "$mod" = "SUPER";

      bind = [
        # ── Terminal & Apps ──────────────────────────────────────────────
        # gsettings terminal = <Super>Return
        "$mod, Return, exec, $HOME/.nix-profile/bin/kitty"
        # gsettings custom8: <Ctrl>space → nautilus
        "CTRL, space, exec, nautilus"
        # gsettings custom15: <Super>z → ide
        "$mod, Z, exec, $HOME/.bin/ide"

        # ── Window management ────────────────────────────────────────────
        # gsettings close = <Super>w
        "$mod, W, killactive"
        # gsettings minimize = <Super><Alt>comma (no true minimize; send to special ws)
        "$mod ALT, comma, movetoworkspacesilent, special:minimized"
        # gsettings toggle-maximized = <Super><Alt>f (simplified to <Super>f)
        "$mod, F, fullscreen, 1"
        # pop-shell toggle-floating = <Super><Alt>Backslash
        "$mod ALT, backslash, togglefloating"

        # ── Launcher / overview ──────────────────────────────────────────
        # gsettings toggle-overview = <Super>Space
        "$mod, Space, exec, wofi --show drun"
        # gsettings toggle-application-view = <Super><Alt>Space
        "$mod ALT, Space, exec, wofi --show drun"
        # gsettings panel-run-dialog = <Alt>F2
        "ALT, F2, exec, wofi --show run"

        # ── Window / app switching ───────────────────────────────────────
        # gsettings switch-applications = <Super>Tab
        "$mod, Tab, cyclenext"
        "$mod SHIFT, Tab, cyclenext, prev"
        # gsettings switch-windows = <Alt>Tab
        "ALT, Tab, cyclenext"
        "ALT SHIFT, Tab, cyclenext, prev"
        # overview placeholder — hyprexpo pending 0.54 compat fix
        "$mod, grave, cyclenext"

        # ── Focus movement (Super+arrows for focus) ──────────────────────
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # ── Workspace focus (mirrors focus-switch / custom keybindings) ──
        # custom0: <Super>Escape → ws 1
        "$mod, Escape, workspace, 1"
        # custom1: <Super>F2 → ws 2
        "$mod, F2, workspace, 2"
        # custom2: <Super>F1 → ws 3
        "$mod, F1, workspace, 3"
        # custom3: <Super>F3 → ws 4
        "$mod, F3, workspace, 4"
        # custom4: <Super>1 → ws 5
        "$mod, 1, workspace, 5"
        # custom5: <Super>2 → ws 6
        "$mod, 2, workspace, 6"
        # custom6: <Super>3 → ws 7
        "$mod, 3, workspace, 7"
        # custom7: <Super>4 → ws 8
        "$mod, 4, workspace, 8"
        # custom14: <Super><Alt>1 → force ws 5
        "$mod ALT, 1, workspace, 5"

        # ── Move window to workspace ─────────────────────────────────────
        # gsettings move-to-workspace-*
        "$mod SHIFT, Escape, movetoworkspace, 1"
        "$mod SHIFT, F2, movetoworkspace, 2"
        "$mod SHIFT, F1, movetoworkspace, 3"
        "$mod SHIFT, F3, movetoworkspace, 4"
        "$mod SHIFT, 1, movetoworkspace, 5"
        "$mod SHIFT, 2, movetoworkspace, 6"
        "$mod SHIFT, 3, movetoworkspace, 7"
        "$mod SHIFT, 4, movetoworkspace, 8"

        # ── System ──────────────────────────────────────────────────────
        # gsettings screensaver = <Super><Alt>l
        "$mod ALT, L, exec, hyprlock"
        # custom12: <Super><Alt>k → suspend
        "$mod ALT, K, exec, systemctl suspend"
        # custom9: <Super><Alt>e → quit session
        "$mod ALT, E, exit"
        # custom11: <Super><Alt>p → 1password
        "$mod ALT, P, exec, /usr/bin/1password --quick-access"
        # custom10: <Super><Alt>m → clean notifications
        "$mod ALT, M, exec, makoctl dismiss --all"
        # gsettings toggle-message-tray = <Alt><Super>n → restore last notification
        "$mod ALT, N, exec, makoctl restore"
        # switch-monitor = <Super><Alt>d / XF86Display
        "$mod ALT, D, exec, $HOME/.bin/monitor-switch now"
        ", XF86Display, exec, $HOME/.bin/monitor-switch now"
        # custom13: <Super><Alt>r → rebalance
        "$mod ALT, R, exec, hyprctl dispatch layoutmsg preselect l"

        # ── Master layout controls ───────────────────────────────────────
        # Promote focused window to master (most important binding)
        "$mod SHIFT, Return, layoutmsg, swapwithmaster"
        # Cycle through stack
        "$mod ALT, Y, layoutmsg, cyclenext"
        # toggle-stacking-global = <Super><Alt>s → swap master/stack orientation
        "$mod ALT, S, layoutmsg, orientationnext"
        # tile-orientation = <Super><Alt>o → rotate orientation
        "$mod ALT, O, layoutmsg, orientationnext"
        # tile-move-*-global = <Super><Alt>arrows
        "$mod ALT, left, movewindow, l"
        "$mod ALT, right, movewindow, r"
        "$mod ALT, up, movewindow, u"
        "$mod ALT, down, movewindow, d"
        # tile-enter = <Super><Alt>Backspace → enter resize submap
        "$mod ALT, Backspace, submap, resize"

        # ── Screenshots ──────────────────────────────────────────────────
        # gsettings screenshot = <Shift>Print
        "SHIFT, Print, exec, grimblast --notify copy area"
        # gsettings screenshot-window = <Alt>Print
        "ALT, Print, exec, grimblast --notify copy active"
        # bonus: full screen
        ", Print, exec, grimblast --notify copy screen"
      ];

      bindm = [
        # gsettings mouse-button-modifier = <Super>
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Resize submap — mirrors pop-shell tile-enter + arrow keys
      submap = {
        resize = {
          binde = [
            ", left, resizeactive, -20 0"
            ", right, resizeactive, 20 0"
            ", up, resizeactive, 0 -20"
            ", down, resizeactive, 0 20"
          ];
          bind = [
            ", Escape, submap, reset"
            ", Return, submap, reset"
          ];
        };
      };

      exec-once = [
        "waybar"
        "mako"
        "swww-daemon"
        "hypridle"
        "nm-applet --indicator"
        "blueman-applet"
        "udiskie --tray"
        "wlsunset -T 6500 -t 3500"
        "/usr/bin/1password --silent"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "hyprctl setcursor Bibata-Modern-Ice 24"
        "sleep 1 && swww img $HOME/.homesick/repos/dotfiles/wallpapers/unsplash.jpg --transition-type wipe --transition-angle 30"
      ];
    };
  };

  # ── Waybar ────────────────────────────────────────────────────────────────
  programs.waybar.enable = true;

  home.file.".config/waybar/config.jsonc".text = ''
    {
      "layer": "top",
      "position": "top",
      "height": 36,
      "spacing": 4,
      "margin-top": 6,
      "margin-left": 10,
      "margin-right": 10,

      "modules-left": [
        "hyprland/workspaces",
        "hyprland/window"
      ],
      "modules-center": [
        "clock"
      ],
      "modules-right": [
        "tray",
        "custom/colortemp",
        "backlight",
        "pulseaudio",
        "network",
        "bluetooth",
        "battery",
        "custom/power"
      ],

      "hyprland/workspaces": {
        "format": "{icon}",
        "format-icons": {
          "1": "\uf121",
          "2": "\uf489",
          "3": "\uf07b",
          "4": "\uf1de",
          "5": "\udb80\udcb1",
          "6": "\uf0e0",
          "7": "\uf537",
          "8": "\uf1b6",
          "urgent": "\uf06a",
          "active": "\uf111",
          "default": "\uf10c"
        },
        "on-click": "activate",
        "sort-by-number": true
      },

      "hyprland/window": {
        "max-length": 50,
        "separate-outputs": true
      },

      "clock": {
        "format": "{:%H:%M}",
        "format-alt": "{:%A, %d %B %Y  %H:%M:%S}",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "interval": 1
      },

      "tray": {
        "icon-size": 16,
        "spacing": 10
      },

      "custom/colortemp": {
        "exec": "echo '\uf46a'",
        "on-click": "pkill wlsunset || wlsunset -T 6500 -t 3500",
        "tooltip": true,
        "tooltip-format": "Toggle night mode",
        "format": "{}",
        "interval": "once"
      },

      "backlight": {
        "format": "{icon} {percent}%",
        "format-icons": ["\udb81\udc9e", "\udb81\udc9f", "\udb81\udca0"],
        "on-scroll-up": "brightnessctl set +2%",
        "on-scroll-down": "brightnessctl set 2%-"
      },

      "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-muted": "\udb81\udd1f",
        "format-icons": {
          "default": ["\udb81\udd7d", "\udb81\udd81", "\udb81\udd7e"]
        },
        "on-click": "pavucontrol",
        "on-click-right": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
        "scroll-step": 2
      },

      "network": {
        "format-wifi": "\udb82\udd28 {signalStrength}%",
        "format-ethernet": "\udb80\udc00",
        "format-disconnected": "\udb82\udd2d",
        "tooltip-format-wifi": "{essid} ({signalStrength}%)\n{ipaddr}",
        "tooltip-format-ethernet": "{ifname}\n{ipaddr}",
        "on-click": "nm-connection-editor"
      },

      "bluetooth": {
        "format": "\udb80\udcaf",
        "format-connected": "\udb80\udcb1 {device_alias}",
        "format-off": "\udb80\udcb2",
        "tooltip-format": "{controller_alias} {controller_address}",
        "tooltip-format-connected": "{controller_alias}\n\n{num_connections} connected\n{device_enumerate}",
        "on-click": "blueman-manager"
      },

      "battery": {
        "states": { "warning": 30, "critical": 15 },
        "format": "{icon} {capacity}%",
        "format-charging": "\udb80\udc84 {capacity}%",
        "format-icons": ["\udb80\udcfa", "\udb80\udcfb", "\udb80\udcfc", "\udb80\udcfd", "\udb80\udcfe", "\udb80\udcff", "\udb80\udd00", "\udb80\udd01", "\udb80\udd02", "\udb80\udd79"],
        "tooltip-format": "{timeTo}"
      },

      "custom/power": {
        "format": "\udb80\udc90",
        "on-click": "wlogout",
        "tooltip": false
      }
    }
  '';

  home.file.".config/waybar/style.css".text = ''
    /* 4. Pill-shaped modules — macOS-like frosted glass bar */
    * {
      font-family: "Inter", "JetBrainsMono Nerd Font", sans-serif;
      font-size: 13px;
      border: none;
      border-radius: 0;
      min-height: 0;
      transition: all 0.2s ease;
    }

    /* Bar itself — semi-transparent so layer blur shows through */
    window#waybar {
      background: rgba(26, 27, 38, 0.45);
      border-radius: 14px;
      border: 1px solid rgba(59, 66, 97, 0.4);
      color: #c0caf5;
    }

    .modules-left,
    .modules-center,
    .modules-right {
      background: transparent;
      padding: 0 2px;
    }

    /* ── Workspace pills ─────────────────────────────────────────────── */
    #workspaces {
      background: rgba(31, 35, 53, 0.6);
      border-radius: 20px;
      margin: 4px 6px;
      padding: 0 4px;
      border: 1px solid rgba(59, 66, 97, 0.3);
    }

    #workspaces button {
      padding: 2px 10px;
      background: transparent;
      color: #565f89;
      border-radius: 16px;
      margin: 2px;
      font-size: 14px;
    }

    #workspaces button:hover {
      background: rgba(122, 162, 247, 0.15);
      color: #7aa2f7;
    }

    #workspaces button.active {
      background: rgba(122, 162, 247, 0.25);
      color: #7aa2f7;
    }

    #workspaces button.urgent {
      background: rgba(247, 118, 142, 0.25);
      color: #f7768e;
    }

    /* ── Window title ────────────────────────────────────────────────── */
    #window {
      background: rgba(31, 35, 53, 0.5);
      border-radius: 20px;
      color: #a9b1d6;
      padding: 4px 14px;
      margin: 4px 4px;
      font-style: italic;
      font-size: 12px;
      border: 1px solid rgba(59, 66, 97, 0.3);
    }

    /* ── Clock pill ──────────────────────────────────────────────────── */
    #clock {
      background: rgba(31, 35, 53, 0.6);
      border-radius: 20px;
      color: #c0caf5;
      font-weight: 600;
      font-size: 13px;
      padding: 4px 18px;
      margin: 4px;
      border: 1px solid rgba(59, 66, 97, 0.3);
    }

    /* ── Right-side modules — individual pills ───────────────────────── */
    #tray,
    #pulseaudio,
    #network,
    #bluetooth,
    #battery,
    #backlight,
    #custom-colortemp,
    #custom-power {
      background: rgba(31, 35, 53, 0.6);
      border-radius: 20px;
      color: #a9b1d6;
      padding: 4px 12px;
      margin: 4px 3px;
      border: 1px solid rgba(59, 66, 97, 0.3);
    }

    #tray {
      padding: 4px 8px;
    }

    #tray:hover,
    #pulseaudio:hover,
    #network:hover,
    #bluetooth:hover,
    #backlight:hover,
    #custom-colortemp:hover {
      background: rgba(122, 162, 247, 0.2);
      color: #7aa2f7;
      border-color: rgba(122, 162, 247, 0.3);
    }

    /* ── Status colors ───────────────────────────────────────────────── */
    #network.disconnected { color: #f7768e; }
    #battery.warning { color: #ff9e64; }
    #battery.critical {
      color: #f7768e;
      border-color: rgba(247, 118, 142, 0.4);
      animation: blink 1s steps(1) infinite;
    }
    #pulseaudio.muted { color: #565f89; }
    #bluetooth.off { color: #565f89; }

    #custom-power {
      color: #f7768e;
      border-color: rgba(247, 118, 142, 0.2);
      margin-right: 6px;
    }

    #custom-power:hover {
      background: rgba(247, 118, 142, 0.2);
      border-color: rgba(247, 118, 142, 0.4);
    }

    @keyframes blink {
      to { opacity: 0.5; }
    }

    /* ── Tooltip ─────────────────────────────────────────────────────── */
    tooltip {
      background: rgba(26, 27, 38, 0.95);
      border: 1px solid rgba(59, 66, 97, 0.6);
      border-radius: 10px;
      color: #c0caf5;
      padding: 6px;
    }

    tooltip label {
      color: #c0caf5;
    }
  '';

  # ── Mako notifications ────────────────────────────────────────────────────
  services.mako = {
    enable = true;
    settings = {
      background-color = "#1f2335ee";
      text-color = "#c0caf5";
      border-color = "#7aa2f7";
      border-radius = 12;
      border-size = 2;
      default-timeout = 5000;
      font = "JetBrainsMono Nerd Font 11";
      width = 380;
      height = 120;
      padding = "16";
      margin = "16";
      icons = true;
      max-icon-size = 48;
    };
    extraConfig = ''
      [urgency=high]
      border-color=#f7768e
      default-timeout=0
    '';
  };

  # ── Hyprlock lockscreen ───────────────────────────────────────────────────
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 2;
        hide_cursor = true;
      };
      background = [
        {
          path = "$HOME/.homesick/repos/dotfiles/wallpapers/unsplash.jpg";
          blur_passes = 3;
          blur_size = 8;
          brightness = 0.5;
        }
      ];
      input-field = [
        {
          size = "300, 50";
          position = "0, -100";
          monitor = "";
          dots_center = true;
          fade_on_empty = true;
          placeholder_text = "";
          font_color = "rgb(c0caf5)";
          inner_color = "rgb(1a1b26)";
          outer_color = "rgb(7aa2f7)";
          outline_thickness = 2;
          rounding = 12;
          shadow_passes = 2;
          shadow_size = 10;
        }
      ];
      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
          color = "rgba(c0caf5ee)";
          font_size = 72;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # ── Hypridle ──────────────────────────────────────────────────────────────
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 600;
          on-timeout = "brightnessctl -s set 10%";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # ── GTK theme ─────────────────────────────────────────────────────────────
  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark-B";
      package = pkgs.tokyonight-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    font = {
      name = "Inter";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = false;
  };

  # ── Wofi launcher ─────────────────────────────────────────────────────────
  home.file.".config/wofi/config".text = ''
    width=500
    height=400
    prompt=
    image_size=24
    allow_images=true
    allow_markup=true
    no_actions=true
    term=kitty
    hide_scroll=true
    show=drun
    insensitive=true
    dynamic_lines=true
    location=center
  '';

  home.file.".config/wofi/style.css".text = ''
    window {
      background-color: rgba(26, 27, 38, 0.95);
      border: 2px solid #3b4261;
      border-radius: 16px;
    }

    #input {
      background-color: rgba(31, 35, 53, 0.9);
      border: 1px solid #3b4261;
      border-radius: 10px;
      color: #c0caf5;
      padding: 10px 16px;
      margin: 12px;
      font-family: "JetBrainsMono Nerd Font";
      font-size: 14px;
    }

    #input:focus {
      border-color: #7aa2f7;
      outline: none;
    }

    #inner-box {
      padding: 0 8px 8px 8px;
    }

    #entry {
      border-radius: 10px;
      padding: 8px 12px;
      margin: 2px 0;
    }

    #entry:selected {
      background-color: rgba(122, 162, 247, 0.2);
      outline: none;
    }

    #entry:selected #text {
      color: #7aa2f7;
    }

    #text {
      color: #c0caf5;
      font-family: "JetBrainsMono Nerd Font";
      font-size: 13px;
    }

    #img {
      margin-right: 8px;
    }
  '';

  # ── Packages ──────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    mako
    wofi
    swww
    hyprlock
    hypridle
    hyprpicker
    grimblast
    wl-clipboard
    wlsunset
    networkmanagerapplet
    blueman
    udiskie
    nwg-displays
    pavucontrol
    wlogout
    papirus-icon-theme
    tokyonight-gtk-theme
    bibata-cursors
    inter
    xdg-desktop-portal-gtk
    libsForQt5.qt5ct
    kdePackages.qt6ct
    polkit_gnome
  ];
}
