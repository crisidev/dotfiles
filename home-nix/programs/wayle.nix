{
  pkgs,
  config,
  ...
}:
let
  nixGL = import ../nixGL.nix { inherit pkgs config; };
  # Wayle is GTK4 — wrap it with nixGL so it finds OpenGL on this non-NixOS host,
  # exactly like kitty / ghostty / hyprland. The wrapper preserves every binary
  # (wayle, wayle-settings) and forwards subcommands, so `wayle shell`,
  # `wayle wallpaper set …`, `wayle notify …` all keep working.
  waylePkg = nixGL pkgs.wayle;

  tokyonight = {
    bg = "#1a1b26"; # darkest base
    surface = "#1f2335"; # cards / sidebars
    elevated = "#292e42"; # raised elements
    fg = "#c0caf5"; # primary text
    "fg-muted" = "#9aa5ce"; # secondary text
    primary = "#7aa2f7"; # accent (blue)
    red = "#f7768e";
    yellow = "#e0af68";
    green = "#9ece6a";
    blue = "#7aa2f7";
  };

  # Calm, unified module styling. Wayle's defaults hand every status module its
  # own semantic colour (red netstat, green ram, blue cpu, yellow storage …),
  # which reads as a rainbow. Instead: a grey-blue glyph, a plain-fg label, and
  # a transparent chip everywhere. Colour is then reserved for genuine *state*
  # (the battery thresholds below) and for the active workspace (Wayle's built-in
  # blue accent) — never decoration.
  neutral = {
    icon-color = "fg-muted";
    icon-bg-color = "transparent";
    label-color = "fg-default";
  };

  # Colourful-but-coherent variant: a neutral module (transparent chip, white
  # label) whose glyph is tinted a canonical Tokyo Night hue. Unlike Wayle's
  # default rainbow, every colour here is a real TN palette colour and the
  # labels stay readable `fg` — only the icon carries the hue.
  tinted = hex: neutral // {
    icon-color = hex;
  };

  # Tokyo Night hues (hex, so we're not limited to the 4 palette slots).
  tn = {
    blue = "#7aa2f7";
    cyan = "#7dcfff";
    teal = "#73daca";
    green = "#9ece6a";
    yellow = "#e0af68";
    orange = "#ff9e64";
    red = "#f7768e";
    magenta = "#bb9af7";
  };
in
{
  # Wayle shell + night-light backend used by its hyprsunset module.
  home.packages = [
    waylePkg
    pkgs.hyprsunset
    # Wayle's wallpaper engine shells out to awww (the swww fork; `pkgs.swww` is
    # now just an alias for it). Without it, `wayle wallpaper set` fails with
    # "neither awww nor swww found in PATH" and there's no background.
    pkgs.awww
  ];

  # ── Wayle configuration ─────────────────────────────────────────────────────
  # Written declaratively; Wayle hot-reloads on change. Every unset key keeps its
  # built-in default (see `wayle config default --stdout`). GUI/CLI tweaks land in
  # runtime.toml and layer on top, so live experiments won't fight this file.
  xdg.configFile."wayle/config.toml".source =
    (pkgs.formats.toml { }).generate "wayle-config.toml"
      {
        general = {
          font-sans = "Inter";
          font-mono = "JetBrains Mono";
        };

        # ── Bar: a clean, GNOME-style top panel ─────────────────────────────
        bar = {
          location = "top";
          exclusive = true;
          layer = "top";
          bg = "bg-surface";
          # Transparent bar → frosted glass, since Hyprland blurs the `wayle`
          # layer namespace (see layerrule in hyprland.nix). Lower = more
          # see-through; the blur keeps text/icons readable.
          background-opacity = 70;
          border-location = "bottom";
          border-width = 1;
          border-color = "border-accent";
          rounding = "none";
          padding = 0.35; # Wayle default bar thickness
          module-gap = 0.5;

          # Remove the "button" chrome so modules float on the frosted bar:
          #   button-bg-opacity   → per-module button background fill (0 = gone)
          #   button-group-opacity → cluster group background (e.g. sysmon's
          #                          bg-elevated block) (0 = gone)
          #   button-border-location → drop the 1 px per-button outline; with a
          #                            transparent fill it would otherwise leave
          #                            empty boxes.
          button-bg-opacity = 0;
          button-group-opacity = 0;
          button-border-location = "none";

          layout = [
            {
              monitor = "*";
              show = true;
              # Single Wayle bar (Wayle can't render a second). Left: workspaces
              # + current window title. Right: metrics, caffeine, notifications,
              # the audio/wifi/bluetooth/battery cluster, date, tray, dashboard.
              left = [
                "hyprland-workspaces"
                "window-title"
              ];
              center = [ ];
              right = [
                "systray"
                # metrics
                {
                  name = "sysmon";
                  modules = [
                    "storage"
                    "netstat"
                    "ram"
                    "cpu"
                  ];
                }
                # network / bluetooth / audio / battery — each opens its own dropdown
                {
                  name = "status";
                  modules = [
                    "network"
                    "bluetooth"
                    "volume"
                    "battery"
                  ];
                }
                "clock" # date
                "notifications"
                # dashboard = the control center (lock / logout / reboot / poweroff)
                "dashboard"
              ];
            }
          ];
        };

        # ── Theme: TokyoNight ───────────────────────────────────────────────
        styling = {
          theme-provider = "wayle";
          palette = tokyonight;
        };

        # ── Per-module tweaks + unified colour scheme ───────────────────────
        modules = {
          clock = neutral // {
            # 24h, matching the GNOME clock (Mon 13  21:20). Bright `fg` label
            # (via `neutral`) keeps the centre clock as the bar's anchor.
            format = "%a %d  %H:%M";
            dropdown-show-seconds = true;
          };
          # Active workspace = blue accent (Wayle default), occupied = fg-muted,
          # empty = fg-subtle. This is the ONE accent on the bar; left as-is.
          hyprland-workspaces = {
            numbering = "absolute";
            active-indicator = "background";
            # Hide empty workspaces: only active + occupied show. Left at the
            # built-in default `min-workspace-count = 0` (no padding to a fixed
            # count). NB: this also needs the `persistent:true` workspaces gone
            # from hyprland.nix — persistent workspaces are reported by Hyprland
            # even when empty, and with count 0 there's no occupancy filter, so
            # they'd otherwise still show.
            # Show the workspace NUMBER (display-mode defaults to "label"), then
            # the real app icons of whatever windows live on it — icons come
            # from the apps, no hand-picked glyphs.
            app-icons-show = true;
            # An empty workspace shows just a space where the icon would be,
            # instead of Wayle's default minus glyph.
            app-icons-empty = " ";
          };

          # window-title / media stay neutral — they're transient context text,
          # not status, so a bright hue there would just be noise.
          window-title = neutral;
          media = neutral;

          # Full Tokyo Night spectrum: each status/monitor/toggle module gets its
          # own canonical TN glyph colour. Labels stay white (via `tinted`), so
          # numbers read clearly; only the icons carry colour.
          netstat = tinted tn.teal;
          cpu = tinted tn.blue;
          ram = tinted tn.cyan;
          storage = tinted tn.magenta;
          hyprsunset = tinted tn.orange;
          idle-inhibit = tinted tn.yellow;
          volume = tinted tn.green;
          bluetooth = tinted tn.blue;
          network = tinted tn.cyan;

          # Notifications: magenta bar glyph (via `tinted`) plus popup tuning.
          # Position/duration stay on Wayle's defaults (top-right, 5 s).
          # `popup-shadow = false` drops the card's drop shadow (the soft edge
          # around each toast). `popup-urgency-bar = "none"` removes the 2 px
          # inset strip at the top of every card — for normal-urgency toasts
          # that strip is the blue accent, which reads as a stray top border.
          # `popup-margin-y` nudges the stack down from the top edge (px,
          # applied as a layer-shell top margin). The popup *width* isn't a
          # config key; it's set in styles/index.scss.
          notifications = (tinted tn.magenta) // {
            popup-shadow = true;
            popup-urgency-bar = "none";
            popup-margin-y = 12.0;
            popup-margin-x = 12.0;
          };

          # Battery is the one true state signal. Wayle evaluates `thresholds`
          # on the numeric percent and later matches win, so: healthy green,
          # low (≤20 %) yellow, critical (≤10 %) red. (Mute / wifi-down / unread
          # aren't colour knobs in Wayle — those states show via icon swaps.)
          battery = neutral // {
            format = "{{ percent }}%";
            icon-color = "green";
            label-color = "green";
            thresholds = [
              {
                below = 20.0;
                icon-color = "yellow";
                label-color = "yellow";
              }
              {
                below = 10.0;
                icon-color = "red";
                label-color = "red";
              }
            ];
          };

          # Control-center button (lock / logout / reboot / poweroff) — red, the
          # universal power hue. Icon only; this module has no label-color key,
          # so `tinted` can't be used (it would set an unknown key) — set the
          # glyph colour directly.
          dashboard = {
            icon-color = tn.red;
            icon-bg-color = "transparent";
          };
        };

        # ── OSD: volume / brightness popups ─────────────────────────────────
        osd = {
          enabled = true;
          position = "bottom";
          duration = 2000;
        };

        # ── Wallpaper engine (image is set at login from hyprland exec-once) ─
        wallpaper = {
          engine-enabled = true;
          transition-type = "simple";
          transition-duration = 0.7;
          transition-fps = 60;
        };
      };

  # ── User style overrides ──────────────────────────────────────────────────
  # Wayle compiles <config>/styles/index.scss and appends it *after* its own
  # stylesheet, so these rules win. It's the only way to reach properties Wayle
  # doesn't expose as config keys — like the notification popup width. The
  # `--global-scale` var (Wayle's styling.scale) is in scope, so we mirror
  # Wayle's own `calc(<px> * var(--global-scale))` idiom. Default is 340px.
  xdg.configFile."wayle/styles/index.scss".text = ''
    // Wider notification toasts (Wayle default: 340px).
    .notification-popup-card {
      min-width: calc(600px * var(--global-scale));
    }
  '';
}
