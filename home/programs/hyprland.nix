{
  pkgs,
  config,
  inputs,
  ...
}:
let
  nixGL = import ../nixGL.nix { inherit pkgs config; };
  hyprlandPkg = nixGL inputs.hyprland.packages.${pkgs.system}.hyprland;

  # Confirmation dialog for "quit session" (Super+Alt+E). `exit` tears the
  # whole compositor down instantly with no undo, which is easy to trigger by
  # accident; gate it behind a wofi yes/no first. Bare `wofi`/`hyprctl` resolve
  # via the session PATH (see the PATH env below), but prepend the profile bin
  # explicitly so the script works no matter how it's launched.
  exitConfirm = pkgs.writeShellScript "hypr-exit-confirm" ''
    export PATH="${config.home.homeDirectory}/.nix-profile/bin:$PATH"
    choice=$(printf 'Cancel\nLog out' \
      | wofi --dmenu --prompt "Exit Hyprland?" --width 260 --height 180 --cache-file /dev/null)
    [ "$choice" = "Log out" ] && hyprctl dispatch exit
  '';

  # GTK theme — single source of truth so the gtk module, the GTK_THEME env, and
  # dconf all name the SAME theme. (The old config was broken: env said "Tokyo
  # Night Dark" and gtk.theme said "Tokyonight-Dark-B", neither of which the
  # tokyonight-gtk-theme package actually ships, so GTK apps fell back to Adwaita.)
  gtkThemeName = "Orchis-Grey-Dark-Nord";
  gtkThemePackage = pkgs.orchis-theme.override { tweaks = [ "nord" ]; };

  # ── Hyprlock host-PAM shim ────────────────────────────────────────────────
  # hyprlock is a Nix binary, so its dynamic loader only searches the Nix
  # RUNPATH — never /usr/lib/x86_64-linux-gnu. Our /etc/pam.d/hyprlock pins the
  # SYSTEM pam_unix.so by absolute path (Nix's libpam can't find the host module
  # by bare name, and only the host module's setgid unix_chkpwd can read
  # /etc/shadow — see falcon.nix). But that host module has a DT_NEEDED on the
  # host libcrypt.so.1, which the Nix loader can't resolve — so every unlock
  # failed with "PAM unable to dlopen(…/pam_unix.so): libcrypt.so.1: cannot open
  # shared object file" and hyprlock rejected the password. (Fingerprint was
  # unaffected: it goes through hyprlock's own fprintd path, not PAM.)
  #
  # Fix: launch hyprlock with a scoped LD_LIBRARY_PATH exposing ONLY the host
  # libcrypt.so.1 (symlinked into ~/.local/lib/hyprlock, see home.file below).
  # Scoping to a dir holding just that one lib is deliberate — putting all of
  # /usr/lib on LD_LIBRARY_PATH would make the Nix hyprlock load the host
  # glibc/wayland at startup and crash. Verified in hyprlock's exact library
  # context (Nix libpam+libselinux loaded) that exposing only libcrypt lets the
  # host pam_unix.so dlopen cleanly.
  hyprlockLibDir = "${config.home.homeDirectory}/.local/lib/hyprlock";
  hyprlockCmd = pkgs.writeShellScript "hyprlock-host-pam" ''
    export LD_LIBRARY_PATH="${hyprlockLibDir}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    exec ${config.home.homeDirectory}/.nix-profile/bin/hyprlock "$@"
  '';

  # Drop the GTK client-side-decoration shadow/margin so tiled windows sit flush
  # with no wallpaper gap. Ported from the old homeshick gtk-3.0/gtk-4.0/gtk.css.
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
in
{
  # ── Core compositor ───────────────────────────────────────────────────────
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprlandPkg;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    systemd.enable = false;
    # Keep the classic hyprland config format (settings below are hyprlang).
    # The new "lua" default is unrelated to our config; pin explicitly to
    # silence the stateVersion-driven default-change warning.
    configType = "hyprlang";

    plugins = [ ];

    settings = {
      monitor = ",preferred,auto,1.2";

      env = [
        # Hyprland (launched by GDM) inherits a system PATH without
        # ~/.nix-profile/bin, so bare-name execs (wofi, hyprlock, grimblast,
        # hyprctl, and Wayle's discovery of its swww wallpaper backend) fail.
        # handleEnv does a raw setenv with no $-expansion, so set an absolute
        # PATH here with ~/.nix-profile/bin first.
        "PATH,${config.home.homeDirectory}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
        "XCURSOR_THEME,Bibata-Modern-Ice"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "GTK_THEME,${gtkThemeName}"
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "MOZ_ENABLE_WAYLAND,1"
        # grimblast's copysave defaults to $XDG_SCREENSHOTS_DIR, else Pictures.
        # Point it at Pictures/Screenshots so Hyprland-owned shots land there.
        "XDG_SCREENSHOTS_DIR,${config.home.homeDirectory}/Pictures/Screenshots"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        mouse_refocus = false; # focus-change-on-pointer-rest false
        touchpad = {
          natural_scroll = false;
          scroll_factor = 1.0;
        };
        repeat_rate = 71; # ~gsettings repeat-interval 14ms → ~71/s
        repeat_delay = 230; # gsettings delay 230
      };

      binds = {
        # Re-pressing the bind for the workspace you're already on jumps back to
        # the previously focused workspace. So $mod+Escape on terminals (ws1)
        # toggles to firefox (ws2) and back — GNOME's back-and-forth behaviour,
        # applied to every workspace-focus bind below.
        workspace_back_and_forth = true;
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "rgba(7aa2f7ee)";
        "col.inactive_border" = "rgba(3b426166)";
        layout = "dwindle";
        resize_on_border = true;
        allow_tearing = false;
      };

      # i3 / pop-shell-style binary space partitioning
      dwindle = {
        # NB: pseudotiling has no config toggle anymore — use the `pseudo`
        # dispatcher (bound to $mod SHIFT Return below).
        preserve_split = true; # keep split ratios when siblings close
        smart_split = false; # split direction from cursor half, not quadrant
        smart_resizing = true; # resize direction from cursor position on window
        force_split = 2; # always insert the new window on the right / bottom
        default_split_ratio = 1.0;
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
          # `top`: slide in from above the screen (quake-style, matches the
          # htop dropdown anchored under the bar). Default is from the bottom.
          "specialWorkspace, 1, 6, wind, slidevert top"
        ];
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        # NB: `vfr` moved to `debug:vfr` (default true) — no longer a misc option.
      };

      # The update-news / donation popups are drawn by hyprland-qtutils, which
      # isn't installed (and the compositor's PATH — inherited from GDM — lacks
      # ~/.nix-profile/bin anyway, so it couldn't find it). Disabling both stops
      # Hyprland from attempting them, which is what emits the "qtutils not
      # installed" error at startup.
      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      # Layer blur — frosted glass on the Wayle shell + wofi launcher
      layerrule = [
        "blur on, match:namespace wayle"
        "ignore_alpha 0, match:namespace wayle"
        "blur on, match:namespace wofi"
        "ignore_alpha 0, match:namespace wofi"
        "blur on, match:namespace gtk-layer-shell"
        "ignore_alpha 0, match:namespace gtk-layer-shell"
      ];

      # ── Workspaces (dynamic 1–8; GNOME F-row key mapping in binds below) ────
      # No `persistent` rules: workspaces exist only when active or occupied, so
      # the Wayle bar hides empty ones (it shows every workspace Hyprland
      # reports, and with min-workspace-count = 0 there's no occupancy filter —
      # persistent empties would otherwise keep showing). Auto-move rules below
      # still create ws 2/3/5/6 on demand when their apps open.

      # ── Auto-move windows (each app always opens on its workspace) ───────
      # `silent` places the window without pulling focus. Hyprland v3 rule
      # syntax (windowrulev2 is gone): `windowrule = EFFECT value, match:PROP
      # regex`. Two gotchas the parser enforces (src/config/legacy):
      #   • selectors keep the `match:` prefix and a SPACE before the regex:
      #     `match:class ^(foo)$`  (NOT `class:^(foo)$`).
      #   • every effect needs a value — even booleans. `float`/`center` alone
      #     error with "invalid field float: missing a value"; use `float 1`.
      # Classes verified from live windows.
      windowrule = [
        # GNOME auto-move-windows parity. Workspace IDs match the F-row key map
        # below: ferdium/signal land on ws5/ws6 = Super+1/Super+2.
        "workspace 2 silent, match:class ^(org\\.mozilla\\.firefox)$" # firefox → 2 (Super+F2)
        "workspace 3 silent, match:class ^(Spotify)$" # spotify → 3 (Super+F1)
        "workspace 5 silent, match:class ^(ferdium)$" # ferdium → 5 (Super+1)
        "workspace 6 silent, match:class ^(org\\.signal\\.Signal)$" # signal  → 6 (Super+2)

        # ── Float sensible transient / utility windows ──────────────────────
        # GNOME-like default: dialogs, pickers and small settings/utility
        # windows float + centre instead of tiling into the BSP layout. The two
        # verified live are com.wayle.settings and org.gnome.Nautilus; the rest
        # are standard reverse-DNS app-ids for apps that may or may not be
        # installed — an unmatched rule is inert, so it's safe to list them.
        "float 1, match:class ^(com\\.wayle\\.settings)$" # Wayle Settings
        "float 1, match:class ^(org\\.gnome\\.Nautilus)$" # Files (the finder)
        "float 1, match:class ^(xdg-desktop-portal-gtk)$" # GTK open/save dialogs
        "float 1, match:class ^(org\\.gnome\\.Calculator)$" # Calculator
        "float 1, match:class ^(org\\.gnome\\.Settings)$" # GNOME Control Center
        "float 1, match:class ^(org\\.gnome\\.FileRoller)$" # Archive Manager
        "float 1, match:class ^(org\\.gnome\\.DiskUtility)$" # Disks
        "float 1, match:class ^(org\\.pulseaudio\\.pavucontrol|pavucontrol)$" # Volume mixer
        "float 1, match:class ^(nm-connection-editor)$" # Network editor

        # Centre them, and give the two "real" windows a comfortable size (the
        # portal dialog sizes itself, so it only gets centred). NB: percentage
        # sizes ("size 60% 65%") stopped parsing on 0.55 — use monitor-local
        # expressions instead (see the htop dropdown note below).
        "center 1, match:class ^(com\\.wayle\\.settings|org\\.gnome\\.Nautilus|xdg-desktop-portal-gtk|org\\.gnome\\.Calculator|org\\.gnome\\.Settings|org\\.gnome\\.FileRoller|org\\.gnome\\.DiskUtility|pavucontrol|nm-connection-editor)$"
        "size monitor_w*0.6 monitor_h*0.65, match:class ^(com\\.wayle\\.settings|org\\.gnome\\.Settings)$"
        "size monitor_w*0.45 monitor_h*0.55, match:class ^(org\\.gnome\\.Nautilus)$" # Files: smaller finder window

        # Quake-style htop dropdown, opened from the Wayle bar's cpu/ram/procs
        # click actions (htopDropdown in wayle.nix). The window lives on the
        # special:htop workspace, so it slides down from the top edge (the
        # `specialWorkspace … slidevert` animation above) and re-clicking
        # slides it away instead of killing it; quitting htop (q) closes the
        # window and the workspace with it. Sizing gotchas on 0.55:
        #   • `size`/`move` percentages ("size 85% 85%") no longer parse —
        #     rules take monitor-local EXPRESSIONS (space-separated, no spaces
        #     within one): `size monitor_w monitor_h*0.45`.
        #   • `move` ignores the bar's reserved area, so anchor 50 logical px
        #     down — the Wayle bar's height (re-tune if bar padding changes).
        "workspace special:htop, match:class ^(htop-float)$"
        "float 1, match:class ^(htop-float)$"
        "size monitor_w monitor_h*0.45, match:class ^(htop-float)$"
        "move 0 65, match:class ^(htop-float)$"

        # ── User-added floating rules ───────────────────────────────────────
        # Managed by ~/.bin/hypr-float-window. Do NOT remove the marker lines —
        # the script inserts new `float 1` rules between them (and applies them
        # live via hyprctl). Run `home-manager switch` afterwards to persist.
        # FLOAT-RULES:BEGIN
        "float 1, match:class ^(nwg-displays)$" # nwg-displays (hypr-float-window)
        "center 1, match:class ^(nwg-displays)$"
        "size 950 509, match:class ^(nwg-displays)$"
        # FLOAT-RULES:END
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
        "$mod ALT, F, fullscreen, 1"
        # pop-shell toggle-floating = <Super><Alt>Backslash
        "$mod ALT, backslash, togglefloating"

        # ── Launcher / overview ──────────────────────────────────────────
        # gsettings toggle-overview = <Super>Space
        # NB: full path — Hyprland's exec PATH (from GDM) lacks ~/.nix-profile/bin.
        "$mod, Space, exec, $HOME/.nix-profile/bin/wofi --show drun"
        # gsettings toggle-application-view = <Super><Alt>Space
        "$mod ALT, Space, exec, $HOME/.nix-profile/bin/wofi --show drun"

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

        # ── Workspace focus (GNOME parity: Escape/F-row → ws1-4, 1-4 → ws5-8) ─
        # Mirrors the GNOME custom keybindings exactly. F1/F2/F3 emit real
        # function keys on this keyboard (the XF86 media keys need Fn), so
        # there is no clash with the media binds above.
        # custom0: <Super>Escape → ws 1
        "$mod, Escape, workspace, 1"
        # custom1: <Super>F2 → ws 2
        "$mod, F2, workspace, 2"
        # custom2: <Super>F1 → ws 3
        "$mod, F1, workspace, 3"
        # custom3: <Super>F3 → ws 4
        "$mod, F3, workspace, 4"
        # custom4-7: <Super>1-4 → ws 5-8
        "$mod, 1, workspace, 5"
        "$mod, 2, workspace, 6"
        "$mod, 3, workspace, 7"
        "$mod, 4, workspace, 8"

        # ── Move window to workspace (same GNOME mapping, + Shift) ───────
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
        "$mod ALT, L, exec, ${hyprlockCmd}"
        # custom12: <Super><Alt>k → suspend
        "$mod ALT, K, exec, systemctl suspend"
        # custom9: <Super><Alt>e → quit session (with wofi confirmation)
        "$mod ALT, E, exec, ${exitConfirm}"
        # custom11: <Super><Alt>p → 1password
        "$mod ALT, P, exec, /usr/bin/1password --quick-access"
        # custom10: <Super><Alt>m → clean all notifications
        "$mod ALT, M, exec, wayle notify dismiss-all"
        # gsettings toggle-message-tray = <Alt><Super>n → toggle Do Not Disturb
        "$mod ALT, N, exec, wayle notify dnd"
        # switch-monitor = <Super><Alt>d / XF86Display
        "$mod ALT, D, exec, $HOME/.bin/monitor-switch now"
        ", XF86Display, exec, $HOME/.bin/monitor-switch now"
        # custom13: <Super><Alt>r → rebalance
        "$mod ALT, R, exec, hyprctl dispatch layoutmsg preselect l"

        # ── Dwindle (bsp) layout controls ────────────────────────────────
        # pop-shell tile-enter → toggle pseudo-tile on the focused window
        "$mod SHIFT, Return, pseudo"
        # cycle focus through the tree
        "$mod ALT, Y, cyclenext"
        # toggle-stacking-global = <Super><Alt>s → group siblings into tabs
        "$mod ALT, S, togglegroup"
        # tile-orientation = <Super><Alt>o → flip the split direction
        "$mod ALT, O, layoutmsg, togglesplit"
        # tile-move-*-global = <Super><Alt>arrows
        "$mod ALT, left, movewindow, l"
        "$mod ALT, right, movewindow, r"
        "$mod ALT, up, movewindow, u"
        "$mod ALT, down, movewindow, d"
        # tile-enter = <Super><Alt>Backspace → enter resize submap
        "$mod ALT, Backspace, submap, resize"

        # ── Screenshots ──────────────────────────────────────────────────
        # Full path: Hyprland's PATH (from GDM) lacks ~/.nix-profile/bin, so a
        # bare `grimblast` is never found (same reason wofi uses a full path).
        # grimblast bundles its own grim/slurp/wl-clipboard, so this is enough.
        # copysave: clipboard AND a PNG in XDG_SCREENSHOTS_DIR (set above).
        # gsettings screenshot = <Shift>Print
        "SHIFT, Print, exec, $HOME/.nix-profile/bin/grimblast --notify copysave area"
        # gsettings screenshot-window = <Alt>Print
        "ALT, Print, exec, $HOME/.nix-profile/bin/grimblast --notify copysave active"
        # bonus: full screen
        ", Print, exec, $HOME/.nix-profile/bin/grimblast --notify copysave screen"
      ];

      # ── Media / hardware keys ──────────────────────────────────────────
      # GNOME handled these for free; under Hyprland they must be bound. Volume
      # is driven through Wayle's own CLI so its OSD pops natively; brightness
      # via brightnessctl (Wayle's OSD watches the backlight). `bindel` repeats
      # when held, `bindl` still fires while the session is locked.
      bindel = [
        ",XF86AudioRaiseVolume, exec, $HOME/.nix-profile/bin/wayle audio output-volume +5"
        ",XF86AudioLowerVolume, exec, $HOME/.nix-profile/bin/wayle audio output-volume -5"
        ",XF86MonBrightnessUp,   exec, $HOME/.nix-profile/bin/brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, $HOME/.nix-profile/bin/brightnessctl set 5%-"
      ];
      bindl = [
        ",XF86AudioMute,    exec, $HOME/.nix-profile/bin/wayle audio output-mute"
        ",XF86AudioMicMute, exec, $HOME/.nix-profile/bin/wayle audio input-mute"
        ",XF86AudioPlay,  exec, $HOME/.nix-profile/bin/wayle media play-pause"
        ",XF86AudioPause, exec, $HOME/.nix-profile/bin/wayle media play-pause"
        ",XF86AudioNext,  exec, $HOME/.nix-profile/bin/wayle media next"
        ",XF86AudioPrev,  exec, $HOME/.nix-profile/bin/wayle media previous"
      ];

      bindm = [
        # gsettings mouse-button-modifier = <Super>
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Resize submap — defined via extraConfig (traditional format)
      # to avoid nested submap {} syntax leaking bindings to global scope.

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        # Wayle: bar + notifications + OSD + wallpaper + control center
        "$HOME/.nix-profile/bin/wayle shell"
        "hypridle"
        # Auto-mount removable media. No `--tray`: udiskie's SNI tray menu
        # doesn't render under wlroots/Wayland (icon shows but clicking does
        # nothing), so the icon is dead weight. Drives still auto-mount on
        # insert; unmount via the file manager or `udiskie-umount <path>`.
        "udiskie"
        "/usr/bin/1password --silent"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "hyprctl setcursor Bibata-Modern-Ice 24"
        # Set the wallpaper through Wayle's engine once the shell is up
        "sleep 2 && $HOME/.nix-profile/bin/wayle wallpaper set $HOME/.homesick/repos/dotfiles/wallpapers/nix-d-nord-aurora.jpg"

        # ── Startup applications ──────────────────────────────────────
        # kitty is pinned to ws1 at launch; the four apps below are placed by
        # the windowrule auto-move rules above (firefox→2, spotify→3,
        # ferdium→5, signal→6), matching GNOME's auto-move-windows list.
        "[workspace 1 silent] $HOME/.nix-profile/bin/kitty"
        "flatpak run org.mozilla.firefox"
        "flatpak run com.spotify.Client"
        "flatpak run org.ferdium.Ferdium"
        "flatpak run org.signal.Signal"
      ];
    };

    # Resize submap — traditional flat format avoids the nested submap {}
    # block syntax that can leak bindings to the global scope.
    extraConfig = ''
      submap = resize
      binde = , left, resizeactive, -20 0
      binde = , right, resizeactive, 20 0
      binde = , up, resizeactive, 0 -20
      binde = , down, resizeactive, 0 20
      bind = , Escape, submap, reset
      bind = , Return, submap, reset
      submap = reset
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
          # Same wallpaper Hyprland shows on the desktop (set via Wayle in the
          # exec-once above), so lock/unlock is visually continuous instead of
          # swapping to a different photo.
          path = "$HOME/.homesick/repos/dotfiles/wallpapers/nix-d-nord-aurora.jpg";
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
          # Keep the box visible even when empty so it's obvious the screen is
          # locked and waiting for a password. The old `fade_on_empty` hid it
          # entirely, leaving no visual clue that typing would do anything.
          fade_on_empty = false;
          # Note: `##` — hyprlang treats a lone `#` as a comment, so the pango
          # colour must be double-hashed.
          placeholder_text = "<span foreground='##9aa5ce'>🔒 Enter password</span>";
          font_color = "rgb(c0caf5)";
          inner_color = "rgb(1a1b26)";
          outer_color = "rgb(7aa2f7)";
          outline_thickness = 2;
          rounding = 12;
          shadow_passes = 2;
          shadow_size = 10;
          # Feedback states: amber while checking, red on wrong password (with
          # the reason + attempt count), orange outline when Caps Lock is on.
          check_color = "rgb(e0af68)";
          fail_color = "rgb(f7768e)";
          fail_text = "<i>$FAIL ($ATTEMPTS)</i>";
          capslock_color = "rgb(ff9e64)";
        }
      ];
      # Fingerprint unlock via fprintd (hyprlock talks to it directly, separate
      # from the PAM password path). Requires an enrolled finger — run
      # `fprintd-enroll` once if `fprintd-verify` says none are enrolled.
      auth = {
        fingerprint = {
          enabled = true;
          ready_message = "Scan fingerprint to unlock";
          present_message = "Scanning…";
        };
      };
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
        lock_cmd = "${hyprlockCmd}";
        before_sleep_cmd = "${hyprlockCmd}";
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
          on-timeout = "${hyprlockCmd}";
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

  # ── GNOME/GTK4 interface (dconf) ──────────────────────────────────────────
  # libadwaita/GTK4 apps (Nautilus, Wayle settings, xdg-portal dialogs) read
  # their font and scaling from dconf, NOT gtk-3.0/settings.ini. A stray
  # text-scaling-factor = 1.25 was stacking on top of the compositor's 1.2
  # monitor scale, making every GTK app render ~1.5x too big. Pin it declaratively
  # so the compositor's monitor scale is the ONLY thing that scales the UI.
  dconf.settings."org/gnome/desktop/interface" = {
    gtk-theme = gtkThemeName;
    text-scaling-factor = 1.0;
    font-name = "Inter 11";
    document-font-name = "Inter 11";
    monospace-font-name = "JetBrainsMono Nerd Font 11";
    color-scheme = "prefer-dark";
    cursor-theme = "Bibata-Modern-Ice";
    cursor-size = 24;
  };

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = false;
  };

  # Expose the host libcrypt.so.1 to the hyprlock shim (hyprlockCmd above). This
  # is the ONLY lib in the dir, so the scoped LD_LIBRARY_PATH can't shadow any of
  # hyprlock's own Nix libs — see the hyprlockCmd comment. Out-of-store symlink
  # so it tracks whatever the host's libcrypt package currently points at.
  home.file.".local/lib/hyprlock/libcrypt.so.1".source =
    config.lib.file.mkOutOfStoreSymlink "/usr/lib/x86_64-linux-gnu/libcrypt.so.1";

  # ── Wofi launcher (command palette) ───────────────────────────────────────
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
      font-size: 18px;
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
      font-size: 16px;
    }

    #img {
      margin-right: 8px;
    }
  '';

  # ── Wayland session file (GDM reads /usr/share/wayland-sessions/) ─────────
  # Written here so it can be copied into /usr/share/wayland-sessions/ (see README).
  #
  # start-hyprland is a watchdog that launches the compositor via
  # execvp("Hyprland", …) — a *bare-name* PATH lookup. GDM's session PATH has no
  # ~/.nix-profile/bin, so a plain `Exec=…/start-hyprland` fails that lookup
  # ("fork(): execvp failed") and GDM drops straight back to the login screen.
  # Passing an absolute --path skips the PATH lookup entirely; --no-nixgl because
  # that target (~/.nix-profile/bin/Hyprland) is itself the nixGL wrapper, so
  # letting start-hyprland re-apply nixGL would just make it hunt for `nixGL` on
  # PATH and hit the same wall. Both paths are the stable profile symlinks, so the
  # copied /usr file keeps working across rebuilds without another sudo cp.
  home.file.".local/share/wayland-sessions/hyprland.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland
    Comment=An intelligent dynamic tiling Wayland compositor
    Exec=${config.home.homeDirectory}/.nix-profile/bin/start-hyprland --no-nixgl --path ${config.home.homeDirectory}/.nix-profile/bin/Hyprland
    Type=Application
    DesktopNames=Hyprland
  '';

  # ── Packages ──────────────────────────────────────────────────────────────
  # Note: bar / notifications / OSD / wallpaper / network+bt+audio applets are
  # all provided by Wayle (see programs/wayle.nix), so mako, wlsunset,
  # nm-applet and blueman-applet are intentionally gone. swww is NOT gone — it
  # is Wayle's wallpaper backend and lives in wayle.nix next to the engine cfg.
  home.packages = with pkgs; [
    hyprlandPkg
    wofi
    hyprlock
    hypridle
    hyprpicker
    # Backs the ANR "app not responding" dialog and (suppressed above) the
    # update-news / donation popups. Found by the compositor via the PATH env
    # directive that prepends ~/.nix-profile/bin.
    hyprland-qtutils
    grimblast
    wl-clipboard
    udiskie
    nwg-displays
    pavucontrol
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
