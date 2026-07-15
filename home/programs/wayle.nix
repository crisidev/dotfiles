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

  # Base module styling: a transparent chip, a grey-blue glyph, and a plain-fg
  # label. A couple of modules keep this bare (media; battery before its state
  # colours kick in), but everything *placed on the bar* layers a rainbow hue on
  # top via `tinted` (see `rainbow` below).
  neutral = {
    icon-color = "fg-muted";
    icon-bg-color = "transparent";
    label-color = "fg-default";
  };

  # Tint a module's glyph while keeping the neutral transparent chip and the
  # readable `fg` label — only the icon carries the hue. Takes a hex colour.
  tinted = hex: neutral // {
    icon-color = hex;
  };

  # Tokyo Night hues (hex, so we're not limited to the 4 palette slots). Only
  # used now for modules that aren't part of the bar rainbow (hyprsunset /
  # idle-inhibit — configured but not placed in the layout).
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

  # ── The bar rainbow ─────────────────────────────────────────────────────────
  # A Tokyo Night rainbow that flows light → dark, one stop per icon, running in
  # visual order from the current-window glyph on the far left across to the
  # dashboard on the far right. Only the glyph is tinted (labels stay readable
  # `fg` via `tinted`); the sequence below IS the on-bar order, so retune the
  # gradient just by editing the hexes. Deliberately excluded: the workspace
  # dots (Wayle's stateful accent), the systray (app-provided icons), and the
  # battery — it stays the bar's one genuine *state* signal (green / yellow /
  # red by charge), so the rainbow flows around it (… volume → [battery] → clock
  # …) rather than through it.
  rainbow = {
    window-title = "#c0caf5"; # lightest — the near-white fg blue
    storage = "#b4f9f8"; # light cyan
    netstat = "#7dcfff"; # cyan
    ram = "#73daca"; # teal
    cpu = "#9ece6a"; # green
    network = "#e0af68"; # yellow
    bluetooth = "#ff9e64"; # orange
    volume = "#f7768e"; # red
    clock = "#bb9af7"; # magenta
    notifications = "#9d7cd8"; # purple
    dashboard = "#3d59a1"; # deep blue — the darkest, far end of the sweep
  };

  # Detailed system monitor, opened from the bar's cpu/ram/procs click actions:
  # a quake-style dropdown that slides from the top edge. The kitty window is
  # pinned to Hyprland's special:htop workspace by windowrules in hyprland.nix
  # (float + full-width + anchored under the bar; the specialWorkspace slidevert
  # animation supplies the slide). First click spawns it — landing on a special
  # workspace auto-reveals it; later clicks toggle the workspace, so htop keeps
  # running in the background instead of restarting cold every time. Quitting
  # htop (q) closes the window and empties the workspace away. kitty/htop/
  # hyprctl resolve via the profile bin (prepended like exitConfirm does —
  # hyprctl must come from the same flake build as the compositor, so it is
  # deliberately NOT pinned to pkgs.hyprland); jq is pinned to the store.
  # htop reflows to whatever size the rule gives the window, so — unlike btop —
  # it needs no fixed initial cell size to avoid a "terminal too small" abort.
  htopDropdown = pkgs.writeShellScript "wayle-htop-dropdown" ''
    export PATH="${config.home.homeDirectory}/.nix-profile/bin:$PATH"
    if hyprctl -j clients \
        | ${pkgs.jq}/bin/jq -e 'any(.[]; .class == "htop-float")' >/dev/null; then
      hyprctl dispatch togglespecialworkspace htop
    else
      kitty --class htop-float htop &
    fi
  '';

  # Wayle 0.6's built-in cpu/ram modules have NO tooltip support — only *custom*
  # modules expose `tooltip-format`. So to get a hover-procs tooltip on cpu and
  # ram, they're reimplemented as custom modules driven by these scripts. Each
  # emits JSON `{ text, tooltip }`: `text` becomes the bar label (replicating the
  # native format), `tooltip` the hover text (top processes). jq assembles the
  # JSON so process names with odd characters can't break it; jq/ps are pinned to
  # the store so they don't depend on the bar's inherited PATH.

  # cpu: percentage (two /proc/stat samples over a short window) + package temp,
  # tooltip = top processes by CPU.
  cpuStats = pkgs.writeShellScript "wayle-cpu-stats" ''
    jq=${pkgs.jq}/bin/jq
    ps=${pkgs.procps}/bin/ps

    # Fields after "cpu ": user nice system idle iowait irq softirq steal …
    # busy = total − idle, where idle counts idle+iowait.
    sample() {
      awk '/^cpu /{ idle = $5 + $6; total = $2+$3+$4+$5+$6+$7+$8+$9; print idle, total; exit }' /proc/stat
    }
    set -- $(sample); idle1=$1; total1=$2
    sleep 0.3
    set -- $(sample); idle2=$1; total2=$2
    dt=$(( total2 - total1 )); di=$(( idle2 - idle1 ))
    if [ "$dt" -gt 0 ]; then
      pct=$(( (100 * (dt - di) + dt / 2) / dt ))
    else
      pct=0
    fi

    # Intel coretemp "Package id 0" (matches the label, since the hwmon index
    # isn't stable). Omitted where absent (e.g. AMD) so the label degrades to
    # just the percentage — same as the old native `temp-sensor` pin did.
    temp=""
    for lf in /sys/class/hwmon/hwmon*/temp*_label; do
      [ -e "$lf" ] || continue
      if [ "$(cat "$lf" 2>/dev/null)" = "Package id 0" ]; then
        milli=$(cat "''${lf%_label}_input" 2>/dev/null) || continue
        temp=$(( (milli + 500) / 1000 ))
        break
      fi
    done
    if [ -n "$temp" ]; then label="''${pct}%  ''${temp}°C"; else label="''${pct}%"; fi

    tip=$(printf 'CPU%%   MEM%%  COMMAND\n'; \
          $ps -eo pcpu,pmem,comm --sort=-pcpu \
            | awk 'NR > 1 && NR <= 9 { printf "%5s  %4s  %s\n", $1, $2, $3 }')

    $jq -n --arg text "$label" --arg tip "$tip" '{ text: $text, tooltip: $tip }'
  '';

  # ram: used/total GiB from /proc/meminfo, tooltip = top processes by memory.
  ramStats = pkgs.writeShellScript "wayle-ram-stats" ''
    jq=${pkgs.jq}/bin/jq
    ps=${pkgs.procps}/bin/ps

    # Used = Total − Available (excludes reclaimable cache/buffers, matching the
    # "used" figure most tools report).
    total_kb=$(awk '/^MemTotal:/{ print $2 }' /proc/meminfo)
    avail_kb=$(awk '/^MemAvailable:/{ print $2 }' /proc/meminfo)
    used_kb=$(( total_kb - avail_kb ))
    label=$(awk -v u="$used_kb" -v t="$total_kb" \
              'BEGIN{ printf "%.1f/%.1fG", u / 1048576, t / 1048576 }')

    tip=$(printf 'MEM%%   CPU%%  COMMAND\n'; \
          $ps -eo pmem,pcpu,comm --sort=-pmem \
            | awk 'NR > 1 && NR <= 9 { printf "%5s  %4s  %s\n", $1, $2, $3 }')

    $jq -n --arg text "$label" --arg tip "$tip" '{ text: $text, tooltip: $tip }'
  '';
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
          module-gap = 0.10; # tighter spacing between modules (left + right)

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
                # Metrics. storage/netstat are native; ram/cpu are custom modules
                # (custom-ram / custom-cpu) so they can carry a hover tooltip of
                # the top processes — Wayle's native cpu/ram can't (see the
                # cpuStats / ramStats scripts). Listed flat rather than in a
                # `sysmon` group: the group background is transparent here
                # (button-group-opacity = 0), so a group would be visually
                # identical, and a group's `modules` list takes native names, not
                # `custom-*` refs.
                "storage"
                "netstat"
                "custom-ram"
                "custom-cpu"
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
          # Scale Wayle's own UI (bar text/icons + notification popups).
          # This is independent of the Hyprland monitor scale (1.2): the
          # compositor sizes the surface, this sizes Wayle's internal layout.
          # Dialed down below 1.0 to shrink bar/notification fonts.
          scale = 0.85;
        };

        # ── Per-module tweaks + unified colour scheme ───────────────────────
        modules = {
          clock = tinted rainbow.clock // {
            # 24h, matching the GNOME clock (Mon 13  21:20). Bright `fg` label
            # (via `tinted`) keeps the centre clock as the bar's anchor; the
            # calendar glyph carries the clock's rainbow stop.
            format = "%a %d  %H:%M";
            dropdown-show-seconds = true;
          };
          # Active workspace = blue accent (Wayle default), occupied = fg-muted,
          # empty = fg-subtle. This is the ONE accent on the bar; left as-is.
          hyprland-workspaces = {
            numbering = "absolute";
            # Active workspace gets a rounded pill wrapping its dot + app icons
            # (the other `active-indicator` option is a thin underline).
            active-indicator = "background";
            # Don't list special workspaces (default true): the htop dropdown
            # lives on special:htop, which would otherwise appear as a "-99"
            # entry in the bar whenever it's open / running in the background.
            show-special = false;
            # Hide empty workspaces: only active + occupied show. Left at the
            # built-in default `min-workspace-count = 0` (no padding to a fixed
            # count). NB: this also needs the `persistent:true` workspaces gone
            # from hyprland.nix — persistent workspaces are reported by Hyprland
            # even when empty, and with count 0 there's no occupancy filter, so
            # they'd otherwise still show.

            # Identity = a filled dot instead of the workspace number. The dot
            # is a text glyph (`●`) rather than an icon, and here's why: Wayle
            # sizes the workspace-map ICON and the app icons with the SAME knob
            # (`icon-size`), so shrinking the dot as an icon shrank the app
            # icons too. Labels have their own `label-size`, so rendering the
            # dot as a label decouples the two — tiny dot, full-size app icons.
            # `display-mode = "label"` shows the label; a per-workspace
            # `workspace-map` label overrides the number. Colour still tracks
            # state (active = accent blue, occupied = fg-muted, empty = subtle).
            display-mode = "label";
            # Map ws 1–8 to a filled-circle glyph; scratchpads (neg IDs) keep
            # their number via the number fallback.
            workspace-map = builtins.listToAttrs (
              map (n: {
                name = toString n;
                value = { label = "●"; };
              }) (builtins.genList (i: i + 1) 8)
            );

            # Size the dot only (labels use `label-size`, not `icon-size`), so
            # app icons stay at their normal `icon-size = 1` default. Tune to
            # taste (range 0.25–3.0).
            label-size = 0.8;

            # Keep the real app icons of whatever windows live on each workspace,
            # shown next to the dot — so the row reads "● 󰈹  ● 󰓇" (dot + app).
            app-icons-show = true;
            # An empty workspace shows just a space where the app icon would be,
            # instead of Wayle's default minus glyph.
            app-icons-empty = " ";
            # Per-app icon overrides (globbed on window class), merged over
            # Wayle's built-in map. The built-in maps `*kitty*` to a Tabler
            # CAT glyph (tb-cat-symbolic) — cute but unreadable at bar size;
            # remap kitty to the plain Lucide terminal glyph so the workspace
            # icon actually reads as a terminal.
            app-icon-map = {
              "*kitty*" = "ld-terminal-symbolic";
            };
          };

          # window-title opens the rainbow: its app-icon glyph is the lightest
          # stop. The label stays neutral `fg` (it's the window title text, not
          # status). media stays fully neutral — it isn't placed on the bar.
          window-title = tinted rainbow.window-title;
          media = neutral;

          # Rainbow stops (light → dark, left → right). Each placed module tints
          # only its glyph; labels stay readable `fg` via `tinted`. cpu/ram are
          # custom modules below, so they're tinted there, not here.
          netstat = tinted rainbow.netstat;
          storage = tinted rainbow.storage;
          volume = tinted rainbow.volume;
          bluetooth = tinted rainbow.bluetooth;
          network = tinted rainbow.network;

          # Not placed on the bar; keep a canonical TN hue for if/when they are.
          hyprsunset = tinted tn.orange;
          idle-inhibit = tinted tn.yellow;

          # cpu / ram as custom modules (referenced as custom-cpu / custom-ram in
          # the layout). Each renders the metric label from its script's JSON
          # `text` and shows the top processes as the hover `tooltip` — the whole
          # point of the rewrite, since native cpu/ram can't do tooltips.
          # Left-click still drops down the htop panel. icon-color carries the
          # rainbow stop; the transparent chip / `fg` label match `tinted`.
          custom = [
            {
              id = "ram";
              command = "${ramStats}";
              mode = "poll";
              interval-ms = 5000;
              icon-name = "ld-memory-stick-symbolic";
              icon-show = true;
              icon-color = rainbow.ram;
              icon-bg-color = "transparent";
              label-show = true;
              label-color = "fg-default";
              left-click = "${htopDropdown}";
            }
            {
              id = "cpu";
              command = "${cpuStats}";
              mode = "poll";
              # 3 s: fresh enough for a load readout without hammering the two
              # /proc/stat samples + a 0.3 s sleep every tick.
              interval-ms = 3000;
              icon-name = "ld-cpu-symbolic";
              icon-show = true;
              icon-color = rainbow.cpu;
              icon-bg-color = "transparent";
              label-show = true;
              label-color = "fg-default";
              left-click = "${htopDropdown}";
            }
          ];

          # Notifications: magenta bar glyph (via `tinted`) plus popup tuning.
          # Position/duration stay on Wayle's defaults (top-right, 5 s).
          # `popup-shadow = false` drops the card's drop shadow (the soft edge
          # around each toast). `popup-urgency-bar = "none"` removes the 2 px
          # inset strip at the top of every card — for normal-urgency toasts
          # that strip is the blue accent, which reads as a stray top border.
          # `popup-margin-y` nudges the stack down from the top edge (px,
          # applied as a layer-shell top margin). The popup *width* isn't a
          # config key; it's set in styles/index.scss.
          notifications = (tinted rainbow.notifications) // {
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
      min-width: calc(384px * var(--global-scale));
    }
  '';
}
