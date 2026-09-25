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
    mkVariant
    mkInt32
    mkTuple
    type
    ;

  home = "/home/${config.home.username}";

  # Typed empty list — dconf needs `@as []` to clear a keybinding, and a bare
  # Nix `[ ]` carries no element type for the gvariant encoder.
  none = mkEmptyArray type.string;

  # Theme names, packages, palette and wallpaper all come from home/theme
  # (Tokyo Night Storm). One name feeds the gtk module (gtk-3.0/settings.ini),
  # dconf, mutter's titlebars and the user-theme shell theme, so they all name
  # the SAME theme. GTK4/libadwaita apps get it via a CSS import (see gtk4 below).
  inherit (config) theme;
  inherit (theme.palette) rgb rgba;
  c = theme.palette.colors;

  # GNOME Shell theme: Orchis restyled as a floating "islands" bar. A thin
  # wrapper theme @imports the nix-built Orchis shell CSS (gnome-shell runs on
  # the host, so it can read /nix/store) and overrides only the panel. The
  # islands are inset by islandInset inside panelHeight, which makes them about
  # as tall as the dock's background.
  panelHeight = 54;
  # "islands": three separate islands (left / centre / right).
  # "bar": one full-width bar with the same fill and border, and the centre
  #        island's tray icons moved into the right box, next to Astra Monitor.
  topBarStyle = "bar";
  islands = topBarStyle == "islands";
  islandInset = 3;
  dockGap = 12; # the floating dock's distance from the bottom edge

  # Astra Monitor, patched: its I/O speed and sensor labels are hardcoded at
  # 0.65em in a "lighter" weight (tiny and faint on the islands bar) and sit
  # tight against the following icon.
  astraMonitor = pkgs.gnomeExtensions.astra-monitor.overrideAttrs (o: {
    postPatch = (o.postPatch or "") + ''
      sed -i 's/font-size: 0\.65em;/font-size: 0.9em;/' \
        src/network/networkHeader.js src/storage/storageHeader.js
      sed -i 's/font-size: 0\.65em;/font-size: 0.8em;/' src/sensors/sensorsHeader.js
      # Graphs: no painted background (was a hardcoded 20% black fill).
      sed -i "s/let bg = 'rgba(0,0,0,0.2)';/let bg = 'rgba(0,0,0,0)';/" src/*/*Graph.js
      cat >> stylesheet.css <<'EOF'

      .astra-monitor-graph-mini {
        border: 1px solid ${rgba c.blue 0.6};
        border-radius: 6px;
      }

      .astra-monitor-header-speed-label,
      .astra-monitor-header-sensors-values-label {
        font-weight: 500;
        color: ${c.fg};
        margin-right: 0.7em;
      }
      EOF
    '';
  });

  # Patched so a workspace with no windows (i.e. the active one; empty
  # inactive ones are hidden) shows a single full-colour placeholder icon from
  # the icon theme, sized like the app icons, instead of nothing.
  emptyWorkspaceIcon = "workspace-switcher";
  workspacesByOpenApps = pkgs.gnomeExtensions.workspaces-indicator-by-open-apps.overrideAttrs (o: {
    postPatch = (o.postPatch or "") + ''
      substituteInPlace workspace.js --replace-fail \
        '    // create apps icons' \
        '    if (windows.length === 0 && !is_other_monitor)
          this.get_child().add_child(new St.Icon({
            icon_name: "${emptyWorkspaceIcon}",
            icon_size: Math.round(this._settings.size_app_icon * this._settings.indicator_height_scale),
            y_align: Clutter.ActorAlign.CENTER,
          }))

        // create apps icons'

      # Outline the active workspace with a full rounded border instead of the
      # 2px underline, and give inactive ones the same border in transparent
      # so nothing shifts. Inline, because the extension's stylesheet
      # ("border: none", 5px radius) outranks the Shell theme.
      substituteInPlace extension.js \
        --replace-fail \
          '`border-bottom-width: ''${indicator_height}px; margin-bottom: 0px;`' \
          '`border-width: ''${indicator_height}px; border-radius: 10px; padding: 2px 5px; margin-bottom: 0px;`' \
        --replace-fail \
          ': `margin-bottom: ''${indicator_height}px;`' \
          ': `border-width: ''${indicator_height}px; border-color: transparent; border-radius: 10px; padding: 2px 5px; margin-bottom: 0px;`'
    '';
  });

  # blur-my-shell pipelines (a{sa{sv}}), as its prefs would write them: the
  # stock gaussian blur followed by a translucent Tokyo Night tint, so the
  # panel/overview/dock blur reads navy instead of neutral grey.
  mkDictionaryEntry =
    k: v:
    lib.hm.gvariant.mkDictionaryEntry [
      k
      v
    ];
  bmsEffect =
    kind: id: params:
    mkVariant [
      (mkDictionaryEntry "type" (mkVariant kind))
      (mkDictionaryEntry "id" (mkVariant id))
      (mkDictionaryEntry "params" (
        mkVariant (lib.mapAttrsToList (k: v: mkDictionaryEntry k (mkVariant v)) params)
      ))
    ];
  bmsPipeline = name: effects: [
    (mkDictionaryEntry "name" (mkVariant name))
    (mkDictionaryEntry "effects" (mkVariant effects))
  ];
  bmsBlur =
    id:
    bmsEffect "native_static_gaussian_blur" id {
      radius = mkInt32 30;
      brightness = 0.6;
    };
  bmsTint =
    id:
    bmsEffect "color" id {
      color = mkTuple (theme.palette.fractions c.bgDark 0.35);
    };

  # Tray-style indicators, in top-bar-organizer's order (see topBarStyle).
  trayIndicators = [
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
  ];

  islandsCss = ''
    #panel #panelLeft,
    #panel #panelCenter,
    #panel #panelRight {
      background-color: ${rgba c.bgDark 0.7};
      border: 2px solid ${rgba c.blue 0.6};
      border-radius: 14px;
      margin-top: ${toString islandInset}px;
      margin-bottom: ${toString islandInset}px;
      padding: 0 4px;
    }
    #panel #panelLeft {
      margin-left: 8px;
    }
    #panel #panelRight {
      margin-right: 8px;
    }
  '';

  # The whole bar as one island, inset like the islands are. #panel's own
  # background needs !important too (Yaru, see above); the boxes stay clear.
  # St's height is the content box: take the inset and the 2px border off so
  # the bar still occupies panelHeight in total.
  barCss = ''
    #panel {
      height: ${toString (panelHeight - 2 * islandInset - 4)}px;
      background-color: ${rgba c.bgDark 0.7} !important;
      border: 2px solid ${rgba c.blue 0.6};
      border-radius: 14px;
      margin: ${toString islandInset}px 8px;
      padding: 0 4px;
    }
  '';

  # Settings left behind by extensions that are gone (or never installed); the
  # staleDconf activation below wipes them. github-manager's held a token.
  staleExtensionSettings = [
    "ding"
    "tiling-assistant"
    "rounded-window-corners-reborn"
    "unsafe-mode-menu"
    "github-manager"
    "tophat"
    "Battery-Health-Charging"
    "space-bar"
  ];

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

  # Start a system-flatpak app at login with the very launcher the dash uses:
  # an out-of-store symlink to its flatpak export, so it tracks the app's own
  # .desktop across flatpak updates. auto-move-windows then places it on its
  # workspace (application-list below).
  flatpakAutostart = app: {
    "autostart/${app}.desktop".source =
      config.lib.file.mkOutOfStoreSymlink "/var/lib/flatpak/exports/share/applications/${app}.desktop";
  };
in
{
  # ── GTK theme ─────────────────────────────────────────────────────────────
  gtk = {
    enable = true;
    theme = { inherit (theme.gtk) name package; };
    iconTheme = { inherit (theme.icons) name package; };
    cursorTheme = { inherit (theme.cursor) name package size; };
    font = {
      name = "Inter";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk3.extraCss = gtkCsdReset;
    # gtk4.theme = gtk.theme makes home-manager @import Orchis's gtk-4.0
    # CSS into ~/.config/gtk-4.0/gtk.css. That user CSS is the only way to theme
    # libadwaita apps (Nautilus), and it also styles mutter-x11-frames (plain
    # GTK4), which draws the titlebars of X11 windows (Bitwarden, and the
    # Electron/CEF flatpaks kept on X11 in flatpak.nix) — macos buttons everywhere.
    # Set explicitly: the implicit default becomes null from stateVersion 26.05.
    gtk4.theme = config.gtk.theme;
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraCss = gtkCsdReset;
  };

  xdg.dataFile."themes/${theme.shell.name}/gnome-shell/gnome-shell.css".text = ''
    @import url("file://${theme.gtk.package}/share/themes/${theme.gtk.name}/gnome-shell/gnome-shell.css");

    /* The bar itself is invisible; its three boxes are the islands.
       !important: Ubuntu's session stacks Yaru under the user theme, and Yaru
       paints #panel #131313 !important. */
    #panel {
      height: ${toString panelHeight}px;
      background-color: transparent !important;
      margin: 0;
      border-radius: 0;
    }
    #panel .panel-corner {
      -panel-corner-opacity: 0;
    }

    ${if islands then islandsCss else barCss}

    /* The dock as one more island: a floating, centred bar (extend-height
       off in dconf) with the same dimmed fill, border and corners as the top
       bar. !important beats Yaru's and ubuntu-dock's own dock styles. dash-to-dock's own
       custom background is off (dconf below): it writes background and border
       colours inline, which would beat this. */
    #dashtodockContainer.bottom #dash .dash-background,
    #dashtodockContainer.bottom.extended #dash .dash-background {
      background-color: ${rgba c.bgDark 0.7} !important;
      border: 2px solid ${rgba c.blue 0.6} !important;
      border-radius: 14px !important;
    }
    /* Dock island geometry: it floats dockGap above the screen edge (the
       background's bottom margin), and is 48px tall like the top islands:
       2px + 44px icon box (32px icon with 6px inner padding) + 2px, so the
       icons sit centred. Running dots are pulled up inside the island, into
       the icon box's lower inner padding. */
    #dashtodockContainer.bottom #dash .dash-background {
      margin-bottom: ${toString dockGap}px !important;
    }
    #dashtodockContainer.bottom #dash .dash-item-container .app-well-app,
    #dashtodockContainer.bottom #dash .dash-item-container .show-apps,
    #dashtodockContainer.bottom #dash .dash-item-container .overview-tile {
      padding-top: 2px !important;
      padding-bottom: ${toString (2 + dockGap)}px !important;
    }
    #dashtodockContainer.bottom #dash .app-grid-running-dot {
      margin-bottom: ${toString (dockGap + 2)}px !important;
    }

    /* No islands (or bar) over the overview, lock and login screens. */
    #panel:overview #panelLeft,
    #panel:overview #panelCenter,
    #panel:overview #panelRight,
    #panel.unlock-screen #panelLeft,
    #panel.unlock-screen #panelCenter,
    #panel.unlock-screen #panelRight,
    #panel.login-screen #panelLeft,
    #panel.login-screen #panelCenter,
    #panel.login-screen #panelRight,
    #panel:overview,
    #panel.unlock-screen,
    #panel.login-screen {
      background-color: transparent !important;
      border-color: transparent !important;
    }

    /* One typeface and weight across the whole bar: clock, battery text and
       Astra Monitor's values (Orchis makes the panel bold; Astra's labels are
       patched to the same weight). */
    #panel,
    #panel StLabel {
      font-family: "Inter" !important;
      font-weight: 500 !important;
    }

    /* Quick-settings indicators (brightness, wifi, volume, power, battery):
       spaced out, sized like Astra Monitor's icons, and all monochrome
       symbolic in the palette foreground instead of mixed full-colour ones. */
    #panel .panel-status-indicators-box {
      spacing: 10px !important;
    }
    #panel .system-status-icon {
      icon-size: 18px !important;
      -st-icon-style: symbolic;
      color: ${c.fg} !important;
      /* symbolic icons' accent parts (charging battery, warnings) */
      success-color: ${c.green} !important;
      warning-color: ${c.yellow} !important;
      error-color: ${c.red} !important;
    }

    /* Hover/active pills inside an island follow its shape. */
    #panel .panel-button {
      border-radius: 10px;
      color: ${c.fg};
    }
    #panel .panel-button.clock-display .clock {
      border-radius: 10px;
    }

    /* Workspaces indicator (workspaces-by-open-apps): no hover/focus glow on
       its buttons. (The active workspace's rounded border is patched into
       the extension itself; see workspacesByOpenApps.) */
    #panel .wboa-panel-rounded,
    #panel .wboa-panel-rounded:hover,
    #panel .wboa-panel-rounded:focus,
    #panel .wboa-panel-rounded:active,
    #panel .wboa-panel-rounded:checked {
      background-color: transparent;
      box-shadow: none;
    }
  '';

  # Extensions from nixpkgs (patched above); see enabled-extensions.
  xdg.dataFile."gnome-shell/extensions/${astraMonitor.extensionUuid}".source =
    "${astraMonitor}/share/gnome-shell/extensions/${astraMonitor.extensionUuid}";
  xdg.dataFile."gnome-shell/extensions/${workspacesByOpenApps.extensionUuid}".source =
    "${workspacesByOpenApps}/share/gnome-shell/extensions/${workspacesByOpenApps.extensionUuid}";

  home.pointerCursor = {
    enable = true;
    inherit (theme.cursor) name package size;
    gtk.enable = true;
    x11.enable = false;
  };

  # Fonts (Inter UI etc.) live in fonts.nix.
  home.packages = [ pkgs.jq ]; # focus-switch

  # Qt apps: qt6ct as the platform theme (configured in qt.nix). environment.d
  # is read by the systemd user manager, which the GNOME session inherits.
  systemd.user.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";

  # ── Session helpers ───────────────────────────────────────────────────────
  # monitor-switch: watch the attached monitor and set text scaling + the kitty
  # font size accordingly. focus-switch startup: land on ws1 with the overview
  # hidden once the extensions are up.
  xdg.configFile =
    autostart "monitor-switch" "${home}/.bin/monitor-switch"
    // autostart "focus-switch" "${home}/.bin/focus-switch startup"
    // flatpakAutostart "org.mozilla.firefox"
    // {
      # X11 launchers from flatpak.nix (they add --ozone-platform=x11).
      "autostart/org.ferdium.Ferdium.desktop".source = ../files/applications/org.ferdium.Ferdium.desktop;
      "autostart/org.signal.Signal.desktop".source = ../files/applications/org.signal.Signal.desktop;
    };
  # NB: Bitwarden's autostart is NOT managed here — the app writes its own
  # entry through the xdg-desktop-portal Background API (X-XDP-Autostart) when
  # its "start on login" setting is toggled; a nix-owned file would fight that.

  home.activation.staleDconf = lib.hm.dag.entryAfter [ "dconfSettings" ] ''
    ${lib.concatMapStrings (e: ''
      run ${pkgs.dconf}/bin/dconf reset -f /org/gnome/shell/extensions/${e}/
    '') staleExtensionSettings}
  '';

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
        workspacesByOpenApps.extensionUuid
        "tailscale-status@maxgallup.github.com"
        "top-bar-organizer@julian.gse.jsts.xyz"
        "ubuntu-dock@ubuntu.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "window-calls@domandoman.xyz"
        "windowIsReady_Remover@nunofarruca@gmail.com"
      ];
      disabled-extensions = [
        "ding@rastersoft.com"
        "space-bar@luchrioh"
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

    "org/gnome/shell/extensions/user-theme".name = theme.shell.name;

    "org/gnome/shell/extensions/pop-shell" = {
      tile-by-default = true;
      snap-to-grid = false;
      active-hint = true;
      active-hint-border-radius = mkUint32 12;
      hint-color-rgba = rgb c.blue;
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
      top-bar-height = panelHeight + 2; # keep the old 2px margin over the bar
    };

    "org/gnome/shell/extensions/top-bar-organizer" = {
      left-box-order = [
        "activities"
      ];
      # Centre island: tray-style indicators. Right island: system monitor,
      # quick settings and the clock, rightmost. In "bar" style the tray
      # indicators move to the right box, just before the system monitor.
      center-box-order = lib.optionals islands trayIndicators;
      right-box-order = lib.optionals (!islands) trayIndicators ++ [
        "monitor@astraext.github.io"
        "quickSettings"
        "dateMenu"
      ];
    };

    # Blur my shell. Components use the global brightness/sigma (their own
    # values only apply with customize = true); the tint lives in the pipelines.
    "org/gnome/shell/extensions/blur-my-shell".pipelines = [
      (mkDictionaryEntry "pipeline_default" (
        bmsPipeline "Default" [
          (bmsBlur "effect_000000000000")
          (bmsTint "effect_000000000003")
        ]
      ))
      (mkDictionaryEntry "pipeline_default_rounded" (
        bmsPipeline "Default rounded" [
          (bmsBlur "effect_000000000001")
          (bmsTint "effect_000000000004")
          (bmsEffect "corner" "effect_000000000002" { radius = mkInt32 24; })
        ]
      ))
    ];
    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      blur = true;
      brightness = 0.6;
      sigma = 30;
    };
    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      # Off like the panel's: it would blur a square behind the rounded dock.
      blur = false;
      # Let the dock paint its own palette background over the blur.
      override-background = false;
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
      # Off: it would blur one strip behind the whole (now transparent) bar
      # instead of the individual islands.
      blur = false;
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
      extend-height = false; # floating island, not edge to edge
      # Auto-hide: not fixed, so windows get the full height; it slides away
      # when a window overlaps it (intellihide) and returns at the bottom edge.
      dock-fixed = false;
      autohide = true;
      intellihide = true;
      height-fraction = 0.9;
      hot-keys = false;
      multi-monitor = false;
      scroll-action = "do-nothing";
      show-apps-at-top = false;
      show-mounts-only-mounted = true;
      show-trash = false;
      apply-custom-theme = false;
      custom-theme-shrink = true;
      # Background, border and corners come from the Shell theme CSS (the
      # dock is styled as a top-bar island); only the running dots are set here.
      custom-background-color = false;
      transparency-mode = "DEFAULT";
      running-indicator-style = "DOTS";
      custom-theme-customize-running-dots = true;
      custom-theme-running-dots-color = c.blue;
      custom-theme-running-dots-border-color = c.blue;
      custom-theme-running-dots-border-width = 0;
    };

    "org/gnome/shell/extensions/alphabetical-app-grid".folder-order-position = "end";

    "org/gnome/shell/extensions/bluetooth-quick-connect" = {
      keep-menu-on-toggle = true;
      refresh-button-on = true;
      show-battery-value-on = true;
    };

    # Workspaces indicator by open apps: the icons of the apps open on each
    # workspace, in the left island; empty workspaces are hidden except the
    # active one, which shows its workspace-names glyph (see the patch above).
    # The active workspace is outlined by a rounded blue border (Shell theme
    # CSS above) instead of the extension's underline and tint.
    "org/gnome/shell/extensions/workspaces-indicator-by-open-apps" = {
      position-in-panel = "LEFT";
      position-index = 0;
      hide-activities-button = true;
      scroll-enable = true;
      scroll-wraparound = false;
      # Must stay on: the patched extension draws the active workspace's
      # rounded border in place of this underline.
      indicator-show-active-workspace = true;
      indicator-show-focused-app = false;
      indicator-color = c.blue;
      indicator-round-borders = true;
      indicator-show-background = false;
      indicator-background-color = rgba c.blue 0.15;
      indicator-background-padding = 4;
      workspace-label-text-color = c.fgDark;
      app-label-text-color = c.fg;
      indicator-show-indexes = false;
      indicator-use-custom-names = true;
      indicator-hide-empty = true;
      apps-inactive-effect = "REDUCE OPACITY";
      apps-minimized-effect = "REDUCE OPACITY";
      size-app-icon = 25;
      size-labels = 20;
      spacing-workspace-left = 3;
      spacing-workspace-right = 3;
      icons-group = "OFF";
    };

    "org/gnome/shell/extensions/notification-banner-reloaded" = {
      anchor-horizontal = 1;
      anchor-vertical = 0;
      animation-direction = 2;
      animation-time = 200;
      padding-horizontal = 0;
      padding-vertical = 0;
    };

    "org/gnome/shell/extensions/caffeine" = {
      show-indicator = "only-active";
      show-notifications = true;
      show-timer = true;
      enable-fullscreen = true;
      restore-state = false;
      screen-blank = "never";
      nightlight-control = "never";
    };

    "org/gnome/shell/extensions/notifications-alert" = {
      blinkrate = 500;
      color = rgb c.red;
    };

    "org/gnome/shell/extensions/tailscale-status".login-server = "https://tailscale.crisidev.org:8443";

    # Astra monitor — palette blue/red accents. Its per-profile JSON blob
    # (`profiles`) is left to the extension; these are the active top-level keys.
    "org/gnome/shell/extensions/astra-monitor" = {
      current-profile = "crisidev";
      # Header graphs 30% wider than the default 30px.
      memory-header-graph-width = 39;
      network-header-graph-width = 39;
      processor-header-graph-width = 39;
      storage-header-graph-width = 39;
      # Fill the island's height (its default caps at 32px and sits high).
      headers-height-override = 43;
      explicit-zero = true;
      monitors-order = ''["storage","network","memory","sensors","processor","gpu"]'';
      memory-header-bars = false;
      memory-header-bars-breakdown = false;
      memory-header-bars-color1 = rgb c.blue;
      memory-header-graph = true;
      memory-header-graph-color1 = rgb c.blue;
      memory-header-icon-alert-color = rgb c.red;
      memory-indicators-order = ''["bar","graph","percentage","value","free","icon"]'';
      memory-menu-swap-color = rgb c.blue;
      network-header-icon-alert-color = rgb c.red;
      network-header-icon-custom = "network-wireless-symbolic";
      network-header-io = true;
      network-header-io-bars-color1 = rgb c.blue;
      network-header-io-bars-color2 = rgb c.red;
      network-header-io-graph-color1 = rgb c.blue;
      network-header-io-graph-color2 = rgb c.red;
      network-indicators-order = ''["IO bar","IO graph","IO speed","icon"]'';
      network-menu-arrow-color1 = rgb c.blue;
      network-menu-arrow-color2 = rgb c.red;
      processor-header-bars = true;
      processor-header-bars-color1 = rgb c.blue;
      processor-header-bars-color2 = rgb c.red;
      processor-header-bars-core = true;
      processor-header-frequency-mode = "max";
      processor-header-graph = false;
      processor-header-graph-color1 = rgb c.blue;
      processor-header-graph-color2 = rgb c.red;
      processor-header-icon-alert-color = rgb c.red;
      processor-indicators-order = ''["bar","graph","percentage","frequency","icon"]'';
      processor-update = 2.0;
      sensors-header-icon-alert-color = rgb c.red;
      sensors-header-sensor1 = ''{"service":"hwmon","path":["coretemp","Package id 0","input"]}'';
      sensors-header-sensor1-show = true;
      sensors-header-show = true;
      sensors-header-tooltip = true;
      sensors-indicators-order = ''["value","icon"]'';
      storage-header-bars-color1 = rgb c.blue;
      storage-header-icon-alert-color = rgb c.red;
      storage-header-io = true;
      storage-header-io-bars-color1 = rgb c.blue;
      storage-header-io-bars-color2 = rgb c.red;
      storage-header-io-graph-color1 = rgb c.blue;
      storage-header-io-graph-color2 = rgb c.red;
      storage-indicators-order = ''["bar","percentage","value","free","IO bar","IO graph","IO speed","icon"]'';
      storage-main = "name-ubuntu--vg-ubuntu--lv";
      storage-menu-arrow-color1 = rgb c.blue;
      storage-menu-arrow-color2 = rgb c.red;
      storage-menu-device-color = rgb c.blue;
    };

    # ── Interface ───────────────────────────────────────────────────────────
    # libadwaita/GTK4 apps (Nautilus, portal dialogs) read font and theme from
    # here, NOT gtk-3.0/settings.ini.
    "org/gnome/desktop/interface" = {
      gtk-theme = theme.gtk.name;
      icon-theme = theme.icons.name;
      color-scheme = "prefer-dark";
      accent-color = "blue";
      font-name = "Inter 11";
      document-font-name = "Inter 11";
      monospace-font-name = "JetBrains Mono 11";
      # macOS-like rendering, matching the fontconfig in fonts.nix.
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      cursor-theme = theme.cursor.name;
      cursor-size = theme.cursor.size;
      clock-show-seconds = true;
      clock-show-weekday = true;
      gtk-enable-primary-paste = true;
    };

    "org/gnome/desktop/background" = {
      picture-uri = theme.wallpaper;
      picture-uri-dark = theme.wallpaper;
      picture-options = "zoom";
      color-shading-type = "solid";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };

    "org/gnome/desktop/screensaver" = {
      picture-uri = theme.wallpaper;
      picture-options = "zoom";
      color-shading-type = "solid";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };

    "org/gnome/desktop/wm/preferences" = {
      theme = theme.gtk.name;
      mouse-button-modifier = "<Super>";
      resize-with-right-button = true;
      focus-mode = "sloppy";
      auto-raise = true;
      num-workspaces = 8;
      # Nerd Font Material Design ("md-") icons as JSON \u escapes (via fromJSON)
      # so the file stays ASCII — raw private-use glyphs get silently dropped by
      # editors/tools. The trailing space stops St clipping the wide md glyphs
      # at their right edge; the leading one balances it so the icon sits
      # centred in its pill. One per workspace, matching auto-move-windows:
      # console, firefox, spotify, webcam, forum (Ferdium), message-lock
      # (Signal), code-braces, dots-grid.
      workspace-names = builtins.fromJSON ''
        [" \udb80\udd8d ", " \udb80\ude39 ", " \udb81\udcc7 ", " \udb81\udda0 ", " \udb80\ude8c ", " \udb83\udfcc ", " \udb80\udd69 ", " \udb85\uddfc "]
      '';
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
