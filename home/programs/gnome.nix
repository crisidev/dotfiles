{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.hm.gvariant)
    mkUint32
    mkUint64
    mkEmptyArray
    type
    ;

  home = "/home/${config.home.username}";

  # Typed empty list — dconf needs `@as []` to clear a keybinding, and a bare
  # Nix `[ ]` carries no element type for the gvariant encoder.
  none = mkEmptyArray type.string;

  # GTK theme — single source of truth so the gtk module (gtk-3.0/settings.ini),
  # dconf, mutter's titlebars and the user-theme shell theme all name the SAME
  # theme. NB: applied to GTK3 apps only; GTK4/libadwaita apps ignore named
  # themes and follow color-scheme = prefer-dark instead (see gtk4.theme below).
  gtkThemeName = "Orchis-Grey-Dark-Nord";
  gtkThemePackage = pkgs.orchis-theme.override { tweaks = [ "nord" ]; };

  wallpaper = "file://${home}/.homesick/repos/dotfiles/wallpapers/nix-d-nord-aurora.jpg";

  # Drop the GTK client-side-decoration shadow/margin so pop-shell tiles sit
  # flush with no wallpaper gap. Ported from the old homeshick gtk-3.0/gtk-4.0/gtk.css.
  gtkCsdReset = ''
    window.csd,
    window.solid-csd,
    window.csd decoration,
    decoration,
    .window-frame,
    .window-frame:backdrop {
        box-shadow: none;
        margin: 0;
        border-radius: 0;
    }
  '';

  # ── Custom keybindings (settings-daemon media-keys) ─────────────────────────
  # Workspace focus goes through ~/.bin/focus-switch (mouse-follows-focus D-Bus
  # API) rather than mutter's switch-to-workspace-N, for back-and-forth toggling
  # and the ferdium second-monitor trick. GNOME F-row/number mapping:
  # Escape/F2/F1/F3 → ws1-4, 1-4 → ws5-8. Order matters only for the dconf path
  # names (customN), which are generated from the list index.
  customKeybindings = [
    {
      binding = "<Super>Escape";
      command = "${home}/.bin/focus-switch 0";
      name = "Switch focus to workspace 1";
    }
    {
      binding = "<Super>F2";
      command = "${home}/.bin/focus-switch 1";
      name = "Switch focus to workspace 2";
    }
    {
      binding = "<Super>F1";
      command = "${home}/.bin/focus-switch 2";
      name = "Switch focus to workspace 3";
    }
    {
      binding = "<Super>F3";
      command = "${home}/.bin/focus-switch 3";
      name = "Switch focus to workspace 4";
    }
    {
      binding = "<Super>1";
      command = "${home}/.bin/focus-switch 4";
      name = "Switch focus to workspace 5";
    }
    {
      binding = "<Super>2";
      command = "${home}/.bin/focus-switch 5";
      name = "Switch focus to workspace 6";
    }
    {
      binding = "<Super>3";
      command = "${home}/.bin/focus-switch 6";
      name = "Switch focus to workspace 7";
    }
    {
      binding = "<Super>4";
      command = "${home}/.bin/focus-switch 7";
      name = "Switch focus to workspace 8";
    }
    {
      binding = "<Ctrl>space";
      command = "nautilus";
      name = "Open nautilus file manager";
    }
    {
      binding = "<Super><Alt>e";
      command = "gnome-session-quit";
      name = "Quit Gnome session";
    }
    {
      binding = "<Super><Alt>m";
      command = "${home}/.bin/clean-notifications";
      name = "Clean all notifications";
    }
    {
      binding = "<Super><Alt>p";
      command = "/usr/bin/1password --quick-access";
      name = "Open 1password quick access";
    }
    {
      binding = "<Super><Alt>k";
      command = "systemctl suspend";
      name = "Suspend system";
    }
    {
      binding = "<Super><Alt>r";
      command = "${home}/.bin/focus-switch rebalance force";
      name = "Rebalance windows";
    }
    {
      binding = "<Super><Alt>1";
      command = "${home}/.bin/focus-switch 4 force";
      name = "Force switch focus to workspace 5";
    }
    {
      binding = "<Super>z";
      command = "${home}/.bin/ide";
      name = "Open IDE";
    }
  ];

  customKeybindingPath =
    i: "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString i}/";

  customKeybindingSettings = lib.listToAttrs (
    lib.imap0 (i: kb: {
      name = lib.removePrefix "/" (lib.removeSuffix "/" (customKeybindingPath i));
      value = kb;
    }) customKeybindings
  );

  # XDG autostart entries (GNOME session runs these at login).
  autostart = name: exec: {
    "autostart/${name}.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=${name}
      Exec=${exec}
      Hidden=false
      NoDisplay=false
      X-GNOME-Autostart-enabled=true
    '';
  };
in
{
  # ── GTK theme ─────────────────────────────────────────────────────────────
  gtk = {
    enable = true;
    theme = {
      name = gtkThemeName;
      package = gtkThemePackage;
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
    gtk3.extraCss = gtkCsdReset;
    # GTK4/libadwaita apps ignore named GTK themes, so don't @import Orchis into
    # gtk-4.0/gtk.css (leave gtk4.theme null); they follow color-scheme = prefer-dark
    # from dconf below. Still apply the CSD reset so they tile flush too.
    gtk4.theme = null;
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraCss = gtkCsdReset;
  };

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = false;
  };

  home.packages = with pkgs; [
    inter
    jq # focus-switch
  ];

  # Qt apps: qt6ct as the platform theme (configured in qt.nix). environment.d
  # is read by the systemd user manager, which the GNOME session inherits.
  systemd.user.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";

  # ── Session helpers ───────────────────────────────────────────────────────
  # monitor-switch: watch the attached monitor and set text scaling + the kitty
  # font size accordingly. focus-switch startup: land on ws1 with the overview
  # hidden once the extensions are up.
  xdg.configFile =
    autostart "monitor-switch" "${home}/.bin/monitor-switch"
    // autostart "focus-switch" "${home}/.bin/focus-switch startup";

  # ── dconf ─────────────────────────────────────────────────────────────────
  # Ported from the old imperative home/.bin/gsettings-update plus the live
  # extension settings. Only the keys listed here are managed; anything else
  # (e.g. astra-monitor's `profiles` blob, extension runtime state) stays as-is.
  #
  # Extensions themselves are installed by hand (extensions.gnome.org /
  # Extension Manager into ~/.local/share/gnome-shell/extensions); nix only
  # declares which are enabled and how they're configured.
  #
  # NB: text-scaling-factor is deliberately NOT set — monitor-switch owns it.
  dconf.settings = customKeybindingSettings // {
    # ── Shell & extensions ──────────────────────────────────────────────────
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "activate-window-by-title@lucaswerkmeister.de"
        "adaptive-brightness@dmy3k.github.io"
        "AlphabeticalAppGrid@stuarthayhurst"
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "Battery-Health-Charging@maniacx.github.com"
        "batterytimepercentagecompact@sagrland.de"
        "bluetooth-quick-connect@bjarosze.gmail.com"
        "blur-my-shell@aunetx"
        "caffeine@patapon.info"
        "disable-workspace-switcher-overlay@cleardevice"
        "do-not-disturb-while-screen-sharing-or-recording@marcinjahn.com"
        "monitor@astraext.github.io"
        "mouse-follows-focus@crisidev.org"
        "notification-banner-reloaded@marcinjakubowski.github.com"
        "notifications-alert-on-user-menu@hackedbellini.gmail.com"
        "pop-shell@system76.com"
        "space-bar@luchrioh"
        "tailscale-status@maxgallup.github.com"
        "top-bar-organizer@julian.gse.jsts.xyz"
        "tophat@fflewddur.github.io"
        "ubuntu-dock@ubuntu.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "window-calls-extended@hseliger.eu"
        "window-calls@domandoman.xyz"
        "windowIsReady_Remover@nunofarruca@gmail.com"
      ];
      disabled-extensions = [
        "ding@rastersoft.com"
        "tiling-assistant@ubuntu.com"
        "unsafe-mode-menu@linushdot.local"
        "rounded-window-corners@fxgn"
        "ubuntu-appindicators@ubuntu.com"
        "github-manager@mackdk-on-github"
        "snapd-prompting@canonical.com"
        "snapd-search-provider@canonical.com"
      ];
      favorite-apps = [
        "kitty.desktop"
        "neovim.desktop"
        "org.mozilla.firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "org.ferdium.Ferdium.desktop"
        "org.signal.Signal.desktop"
        "com.spotify.Client.desktop"
        "com.bitwarden.desktop.desktop"
      ];
    };

    "org/gnome/shell/keybindings" = {
      toggle-overview = [ "<Super>Space" ];
      toggle-application-view = [ "<Super><Alt>Space" ];
      toggle-message-tray = [ "<Alt><Super>n" ];
      screenshot = [ "<Shift>Print" ];
      screenshot-window = [ "<Alt>Print" ];
      focus-active-notification = none;
      open-application-menu = none;
      shift-overview-down = none;
      shift-overview-up = none;
      toggle-quick-settings = none;
    }
    // lib.genAttrs (map (n: "switch-to-application-${toString n}") (lib.range 1 9)) (_: none)
    // lib.genAttrs (map (n: "open-new-window-application-${toString n}") (lib.range 1 9)) (_: none);

    "org/gnome/shell/ubuntu".startup-sound = "";

    # Each app always opens on its workspace: firefox → 2,
    # spotify → 3, ferdium → 5, signal → 6.
    "org/gnome/shell/extensions/auto-move-windows".application-list = [
      "org.ferdium.Ferdium.desktop:5"
      "org.signal.Signal.desktop:6"
      "com.spotify.Client.desktop:3"
      "spotify-player.desktop:3"
      "org.mozilla.firefox.desktop:2"
    ];

    "org/gnome/shell/extensions/user-theme".name = gtkThemeName;

    "org/gnome/shell/extensions/pop-shell" = {
      tile-by-default = true;
      snap-to-grid = false;
      active-hint = true;
      active-hint-border-radius = mkUint32 12;
      hint-color-rgba = "rgb(233,233,237)";
      gap-inner = mkUint32 2;
      gap-outer = mkUint32 2;
      mouse-cursor-follows-active-window = false;
      tile-enter = [ "<Super><Alt>Backspace" ];
      tile-accept = [ "Return" ];
      tile-reject = [ "Escape" ];
      tile-orientation = [ "<Super><Alt>o" ];
      toggle-tiling = [ "<Super><Alt>y" ];
      toggle-stacking-global = [ "<Super><Alt>s" ];
      toggle-floating = [ "<Super><Alt>Backslash" ];
      tile-resize-down = [ "Down" ];
      tile-resize-left = [ "Left" ];
      tile-resize-right = [ "Right" ];
      tile-resize-up = [ "Up" ];
      tile-move-down-global = [ "<Super><Alt>Down" ];
      tile-move-left-global = [ "<Super><Alt>Left" ];
      tile-move-right-global = [ "<Super><Alt>Right" ];
      tile-move-up-global = [ "<Super><Alt>Up" ];
      activate-launcher = none;
      pop-monitor-down = none;
      pop-monitor-left = none;
      pop-monitor-right = none;
      pop-monitor-up = none;
      pop-workspace-down = none;
      pop-workspace-up = none;
      tile-move-down = none;
      tile-move-left = none;
      tile-move-right = none;
      tile-move-up = none;
      tile-swap-down = none;
      tile-swap-left = none;
      tile-swap-right = none;
      tile-swap-up = none;
    };

    "org/gnome/shell/extensions/mouse-follows-focus" = {
      bottom-bar-height = 80;
      enable-debugging = false;
      minimum-size-trigger = 9;
      motion-event-timeout = 100;
      top-bar-height = 40;
    };

    "org/gnome/shell/extensions/space-bar/appearance".application-styles = ''
      .space-bar {
        -natural-hpadding: 12px;
      }

      .space-bar-workspace-label.active {
        margin: 0 4px;
        background-color: rgba(255,255,255,0.3);
        color: rgba(255,255,255,1);
        border-color: rgba(0,0,0,0);
        font-weight: 700;
        border-radius: 4px;
        border-width: 0px;
        padding: 3px 8px;
      }

      .space-bar-workspace-label.inactive {
        margin: 0 4px;
        background-color: rgba(0,0,0,0);
        color: rgba(255,255,255,1);
        border-color: rgba(0,0,0,0);
        font-weight: 700;
        border-radius: 4px;
        border-width: 0px;
        padding: 3px 8px;
      }

      .space-bar-workspace-label.inactive.empty {
        margin: 0 4px;
        background-color: rgba(0,0,0,0);
        color: rgba(255,255,255,0.5);
        border-color: rgba(0,0,0,0);
        font-weight: 700;
        border-radius: 4px;
        border-width: 0px;
        padding: 3px 8px;
      }'';

    "org/gnome/shell/extensions/space-bar/shortcuts" = {
      enable-activate-workspace-shortcuts = false;
      activate-empty-key = none;
      activate-previous-key = none;
      move-workspace-left = none;
      move-workspace-right = none;
      open-menu = none;
    };

    "org/gnome/shell/extensions/top-bar-organizer" = {
      left-box-order = [
        "activities"
        "Space Bar"
      ];
      center-box-order = none;
      right-box-order = [
        "TopHat"
        "appindicator-kstatusnotifieritem-unattended-upgrade"
        "appindicator-kstatusnotifieritem-spotify-client"
        "appindicator-kstatusnotifieritem-un-reboot"
        "appindicator-kstatusnotifieritem-steam"
        "appindicator-kstatusnotifieritem-vlc"
        "appindicator-kstatusnotifieritem-chrome_status_icon_1"
        "pop-shell"
        "GithubManager"
        "screenRecording"
        "appindicator-kstatusnotifieritem-software-update-available"
        "screenSharing"
        "dwellClick"
        "a11y"
        "tailscale"
        "keyboard"
        "monitor@astraext.github.io"
        "quickSettings"
        "dateMenu"
      ];
    };

    # Blur my shell
    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      blur = true;
      brightness = 0.6;
      sigma = 30;
    };
    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = true;
      brightness = 0.6;
      pipeline = "pipeline_default";
      sigma = 30;
      static-blur = true;
      style-dash-to-dock = 0;
    };
    "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
      blur = true;
      pipeline = "pipeline_default";
    };
    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      blur = true;
      pipeline = "pipeline_default";
      style-components = 2;
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = true;
      brightness = 0.6;
      force-light-text = false;
      pipeline = "pipeline_default";
      sigma = 37;
      static-blur = true;
      unblur-in-overview = true;
    };
    "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
      blur = true;
      pipeline = "pipeline_default";
    };
    "org/gnome/shell/extensions/blur-my-shell/window-list" = {
      blur = true;
      brightness = 0.6;
      sigma = 30;
    };

    # Ubuntu dock (dash-to-dock schema)
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";
      dash-max-icon-size = 32;
      extend-height = true;
      height-fraction = 0.9;
      hot-keys = false;
      multi-monitor = false;
      scroll-action = "do-nothing";
      show-apps-at-top = false;
      show-mounts-only-mounted = true;
      show-trash = false;
      apply-custom-theme = false;
      custom-theme-shrink = true;
      transparency-mode = "DEFAULT";
    };

    "org/gnome/shell/extensions/alphabetical-app-grid".folder-order-position = "end";

    "org/gnome/shell/extensions/bluetooth-quick-connect" = {
      keep-menu-on-toggle = true;
      refresh-button-on = true;
      show-battery-value-on = true;
    };

    "org/gnome/shell/extensions/notification-banner-reloaded".anchor-horizontal = 1;

    "org/gnome/shell/extensions/notifications-alert" = {
      blinkrate = 500;
      color = "rgb(237,113,137)";
    };

    "org/gnome/shell/extensions/tailscale-status".login-server = "https://tailscale.crisidev.org:8443";

    "org/gnome/shell/extensions/tophat" = {
      mount-to-monitor = "/";
      network-usage-unit = "bits";
      show-cpu = true;
      show-disk = true;
      show-fs = true;
      show-icons = true;
      show-mem = true;
    };

    "org/gnome/shell/extensions/Battery-Health-Charging" = {
      amend-power-indicator = true;
      charging-mode = "ful";
      default-threshold = true;
      show-battery-panel2 = false;
      show-system-indicator = false;
    };

    # Astra monitor — TokyoNight blue/red accents. Its per-profile JSON blob
    # (`profiles`) is left to the extension; these are the active top-level keys.
    "org/gnome/shell/extensions/astra-monitor" = {
      current-profile = "crisidev";
      explicit-zero = true;
      monitors-order = ''["storage","network","memory","sensors","processor","gpu"]'';
      memory-header-bars = false;
      memory-header-bars-breakdown = false;
      memory-header-bars-color1 = "rgb(122,162,247)";
      memory-header-graph = true;
      memory-header-graph-color1 = "rgb(122,162,247)";
      memory-header-icon-alert-color = "rgb(247,118,142)";
      memory-indicators-order = ''["bar","graph","percentage","value","free","icon"]'';
      memory-menu-swap-color = "rgb(122,162,247)";
      network-header-icon-alert-color = "rgb(247,118,142)";
      network-header-icon-custom = "network-wireless-symbolic";
      network-header-io = true;
      network-header-io-bars-color1 = "rgb(122,162,247)";
      network-header-io-bars-color2 = "rgb(247,118,142)";
      network-header-io-graph-color1 = "rgb(122,162,247)";
      network-header-io-graph-color2 = "rgb(247,118,142)";
      network-indicators-order = ''["IO bar","IO graph","IO speed","icon"]'';
      network-menu-arrow-color1 = "rgb(122,162,247)";
      network-menu-arrow-color2 = "rgb(247,118,142)";
      processor-header-bars = true;
      processor-header-bars-color1 = "rgb(122,162,247)";
      processor-header-bars-color2 = "rgb(247,118,142)";
      processor-header-bars-core = true;
      processor-header-frequency-mode = "max";
      processor-header-graph = false;
      processor-header-graph-color1 = "rgb(122,162,247)";
      processor-header-graph-color2 = "rgb(247,118,142)";
      processor-header-icon-alert-color = "rgb(247,118,142)";
      processor-indicators-order = ''["bar","graph","percentage","frequency","icon"]'';
      processor-update = 2.0;
      sensors-header-icon-alert-color = "rgb(247,118,142)";
      sensors-header-sensor1 = ''{"service":"hwmon","path":["coretemp","Package id 0","input"]}'';
      sensors-header-sensor1-show = true;
      sensors-header-show = true;
      sensors-header-tooltip = true;
      sensors-indicators-order = ''["value","icon"]'';
      storage-header-bars-color1 = "rgb(122,162,247)";
      storage-header-icon-alert-color = "rgb(247,118,142)";
      storage-header-io = true;
      storage-header-io-bars-color1 = "rgb(122,162,247)";
      storage-header-io-bars-color2 = "rgb(247,118,142)";
      storage-header-io-graph-color1 = "rgb(122,162,247)";
      storage-header-io-graph-color2 = "rgb(247,118,142)";
      storage-indicators-order = ''["bar","percentage","value","free","IO bar","IO graph","IO speed","icon"]'';
      storage-main = "name-ubuntu--vg-ubuntu--lv";
      storage-menu-arrow-color1 = "rgb(122,162,247)";
      storage-menu-arrow-color2 = "rgb(247,118,142)";
      storage-menu-device-color = "rgb(122,162,247)";
    };

    # ── Interface ───────────────────────────────────────────────────────────
    # libadwaita/GTK4 apps (Nautilus, portal dialogs) read font and theme from
    # here, NOT gtk-3.0/settings.ini.
    "org/gnome/desktop/interface" = {
      gtk-theme = gtkThemeName;
      icon-theme = "Papirus-Dark";
      color-scheme = "prefer-dark";
      accent-color = "purple";
      font-name = "Inter 11";
      document-font-name = "Inter 11";
      monospace-font-name = "JetBrainsMono Nerd Font 11";
      font-antialiasing = "rgba";
      font-hinting = "full";
      cursor-theme = "Bibata-Modern-Ice";
      cursor-size = 24;
      clock-show-seconds = true;
      clock-show-weekday = true;
      gtk-enable-primary-paste = true;
    };

    "org/gnome/desktop/background" = {
      picture-uri = wallpaper;
      picture-uri-dark = wallpaper;
      picture-options = "zoom";
      color-shading-type = "solid";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };

    "org/gnome/desktop/screensaver" = {
      picture-uri = wallpaper;
      picture-options = "zoom";
      color-shading-type = "solid";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };

    "org/gnome/desktop/wm/preferences" = {
      theme = gtkThemeName;
      mouse-button-modifier = "<Super>";
      resize-with-right-button = true;
      focus-mode = "sloppy";
      auto-raise = true;
      num-workspaces = 8;
      workspace-names = [
        " "
        " "
        " "
        " "
        "󰒱 "
        " "
        " "
        " "
      ];
    };

    "org/gnome/mutter" = {
      overlay-key = "";
      dynamic-workspaces = false;
      edge-tiling = false;
      workspaces-only-on-primary = true;
      focus-change-on-pointer-rest = false;
    };

    "org/gnome/desktop/default-applications/terminal" = {
      exec = "${home}/.nix-profile/bin/kitty";
      exec-arg = "-e";
    };

    "org/gnome/nautilus/preferences".thumbnail-limit = mkUint64 10485760;

    "org/gnome/desktop/sound" = {
      event-sounds = false;
      input-feedback-sounds = false;
      theme-name = "Yaru";
    };

    # ── Input ───────────────────────────────────────────────────────────────
    "org/gnome/desktop/peripherals/keyboard" = {
      repeat = true;
      repeat-interval = mkUint32 14;
      delay = mkUint32 230;
    };
    "org/gnome/desktop/peripherals/mouse".natural-scroll = false;
    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "fingers";
      edge-scrolling-enabled = false;
      natural-scroll = false;
      two-finger-scrolling-enabled = true;
    };
    "org/freedesktop/ibus/general/hotkey".triggers = none;
    "org/freedesktop/ibus/panel/emoji".hotkey = none;

    # ── Power / idle ────────────────────────────────────────────────────────
    "org/gnome/desktop/session".idle-delay = mkUint32 300;
    "org/gnome/settings-daemon/plugins/power" = {
      ambient-enabled = false;
      idle-brightness = 240;
      idle-dim = true;
      lid-close-ac-action = "suspend";
      lid-close-battery-action = "suspend";
      lid-close-suspend-with-external-monitor = false;
      power-button-action = "nothing";
      power-saver-profile-on-low-battery = true;
      sleep-inactive-ac-timeout = 3600;
      sleep-inactive-ac-type = "suspend";
      sleep-inactive-battery-timeout = 900;
      sleep-inactive-battery-type = "suspend";
    };

    # ── Keybindings ─────────────────────────────────────────────────────────
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = lib.imap0 (i: _: customKeybindingPath i) customKeybindings;
      screensaver = [ "<Super><Alt>l" ];
      terminal = [ "<Super>Return" ];
      email = [ "<Super>e" ];
      home = [ "<Super>f" ];
      www = [ "<Super>b" ];
      help = none;
      rotate-video-lock-static = none;
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>w" ];
      minimize = [ "<Super><Alt>comma" ];
      toggle-maximized = [ "<Super><Alt>f" ];
      panel-run-dialog = [ "<Alt>F2" ];
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
      switch-group = [
        "<Super>Above_Tab"
        "<Alt>Above_Tab"
      ];
      switch-group-backward = [
        "<Shift><Super>Above_Tab"
        "<Shift><Alt>Above_Tab"
      ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      switch-input-source = [ "XF86Keyboard" ];
      switch-input-source-backward = [ "<Shift>XF86Keyboard" ];
      move-to-workspace-1 = [ "<Super><Shift>Escape" ];
      move-to-workspace-2 = [ "<Super><Shift>F2" ];
      move-to-workspace-3 = [ "<Super><Shift>F1" ];
      move-to-workspace-4 = [ "<Super><Shift>F3" ];
      move-to-workspace-5 = [ "<Super><Shift>1" ];
      move-to-workspace-6 = [ "<Super><Shift>2" ];
      move-to-workspace-7 = [ "<Super><Shift>3" ];
      move-to-workspace-8 = [ "<Super><Shift>4" ];
      activate-window-menu = none;
      cycle-group = none;
      cycle-group-backward = none;
      cycle-windows = none;
      cycle-windows-backward = none;
      maximize = none;
      unmaximize = none;
      move-to-monitor-down = none;
      move-to-monitor-left = none;
      move-to-monitor-right = none;
      move-to-monitor-up = none;
      move-to-workspace-down = none;
      move-to-workspace-last = none;
      move-to-workspace-left = none;
      move-to-workspace-right = none;
      move-to-workspace-up = none;
      panel-main-menu = none;
      switch-to-workspace-down = none;
      switch-to-workspace-left = none;
      switch-to-workspace-right = none;
      switch-to-workspace-up = none;
    }
    // lib.genAttrs (map (n: "switch-to-workspace-${toString n}") (lib.range 1 9)) (_: none);

    "org/gnome/mutter/keybindings" = {
      switch-monitor = [
        "<Super><Alt>d"
        "XF86Display"
      ];
      cancel-input-capture = none;
      toggle-tiled-left = none;
      toggle-tiled-right = none;
    };

    "org/gnome/mutter/wayland/keybindings" = {
      restore-shortcuts = none;
    }
    // lib.genAttrs (map (n: "switch-to-session-${toString n}") (lib.range 1 9)) (_: none);
  };
}
