{
  pkgs,
  config,
  ...
}:
let
  nixGL = import ../nixGL.nix { inherit pkgs config; };
  # Flatpak apps (Firefox, Ferdium, …) deliver notifications through
  # xdg-desktop-portal, which forwards them with an EMPTY app_name and only a
  # `desktop-entry` hint (org.mozilla.firefox, …). Wayle 0.6 groups and labels
  # purely by app_name, so all of those land in one "unknown" group. The patch
  # falls back to the desktop-entry's display name (Wayle already uses that
  # hint for the group icon, just not the label). Drop once upstream fixes it:
  # https://github.com/wayle-rs/wayle
  wayleFixed = pkgs.wayle.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./patches/wayle-notification-desktop-entry.patch ];
  });
  # Wayle is GTK4 — wrap it with nixGL so it finds OpenGL on this non-NixOS host,
  # exactly like kitty / ghostty / hyprland. The wrapper preserves every binary
  # (wayle, wayle-settings) and forwards subcommands, so `wayle shell`,
  # `wayle wallpaper set …`, `wayle notify …` all keep working.
  waylePkg = nixGL wayleFixed;

  # Base is Tokyo Night, with the shifts that had been living as GUI tweaks in
  # runtime.toml folded in (deeper Storm-ish bg/surface, lighter muted text, a
  # cyan-leaning blue) so this file stays the single source of truth.
  tokyonight = {
    bg = "#1f2335"; # base (was #1a1b26; raised to the Storm surface)
    surface = "#24283b"; # cards / sidebars
    elevated = "#292e42"; # raised elements
    fg = "#c0caf5"; # primary text
    "fg-muted" = "#a9b1d6"; # secondary text
    primary = "#7aa2f7"; # accent (blue)
    red = "#f7768e";
    yellow = "#e0af68";
    green = "#9ece6a";
    blue = "#7dcfff"; # cyan-leaning blue
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
  # A Tokyo Night rainbow, one stop per icon, in visual order from the
  # current-window glyph on the far left across to the dashboard on the far
  # right. It broadly trends light → dark, but hue is tuned for legibility over a
  # strict luminance ramp: bluetooth takes its namesake blue, audio is a warm
  # orange (never red), and the clock/notifications pair is split across the hue
  # wheel (magenta vs red) so they don't read as the same colour. Only the glyph
  # is tinted (labels stay readable `fg` via `tinted`); the sequence below IS the
  # on-bar order, so retune just by editing the hexes. Deliberately excluded: the
  # workspace dots (Wayle's stateful accent), the systray (app-provided icons),
  # and the battery — it stays the bar's one genuine *state* signal (green /
  # yellow / red by charge), so the rainbow flows around it rather than through.
  rainbow = {
    window-title = "#c0caf5"; # lightest — near-white lavender
    storage = "#b4f9f8"; # light cyan (disk)
    netstat = "#7dcfff"; # cyan (net traffic)
    ram = "#73daca"; # teal
    cpu = "#9ece6a"; # green
    network = "#e0af68"; # yellow (wifi)
    bluetooth = "#7aa2f7"; # blue — its namesake
    volume = "#ff9e64"; # orange — audio, warm and never red
    clock = "#bb9af7"; # magenta (calendar)
    notifications = "#f7768e"; # red/pink — alerts, split away from the clock
    dashboard = "#3d59a1"; # deep blue — darkest, far end of the sweep
  };

  # Detailed system monitor, opened from the bar's cpu/ram click actions:
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
  # emits JSON `{ text, tooltip[, class] }`: `text` becomes the bar label
  # (replicating the native format), `tooltip` the hover text, and `class` an
  # optional threshold CSS class the stylesheet colours. jq assembles the JSON so
  # process names with odd characters can't break it; jq/ps/etc. are pinned to
  # the store so they don't depend on the bar's inherited PATH.

  # Shared `emit` helper: print the module JSON. A non-empty third arg becomes the
  # `class` field (the threshold class); empty → the field is omitted so Wayle
  # removes any class it had (its diff drops classes absent from the new output).
  emitJson = ''
    emit() { # $1 = label, $2 = tooltip, $3 = css class (may be empty)
      if [ -n "$3" ]; then
        ${pkgs.jq}/bin/jq -n --arg text "$1" --arg tip "$2" --arg class "$3" \
          '{ text: $text, tooltip: $tip, class: $class }'
      else
        ${pkgs.jq}/bin/jq -n --arg text "$1" --arg tip "$2" \
          '{ text: $text, tooltip: $tip }'
      fi
    }
  '';

  # Shared process table for the cpu/ram tooltips: top 15 processes with
  # PID / USER / CPU% / MEM% / RSS / cumulative CPU TIME / COMMAND, differing
  # only in the sort key. Header and rows share one printf format so the
  # columns line up (the tooltip is monospace via styles/index.scss).
  # `user:12` stops ps truncating long usernames to 8 chars + "+"; RSS (KiB)
  # is humanised to M/G; `times` (seconds) is rendered h:mm:ss; the command
  # is everything from field 8 on, so names with spaces survive. Processes
  # younger than 3 s (etimes, field 7 — displayed nowhere) are skipped: ps
  # computes CPU% over the process's lifetime, so newborns (including the ps
  # spawned here) show absurd spikes; rows are counted after that filter so
  # the table stays at 15.
  procTable = sort: ''
    tip=$(printf '%7s  %-10s %5s  %4s  %6s  %8s  %s\n' 'PID' 'USER' 'CPU%' 'MEM%' 'RSS' 'TIME' 'COMMAND'; \
          $ps -eo pid,user:12,pcpu,pmem,rss,times,etimes,comm --sort=${sort} \
            | awk 'NR > 1 && $7 >= 3 && n < 15 {
                n++
                rss = $5
                if (rss >= 1048576)   r = sprintf("%.1fG", rss / 1048576)
                else if (rss >= 1024) r = sprintf("%dM", int(rss / 1024 + 0.5))
                else                  r = rss "K"
                t = $6
                tm = sprintf("%d:%02d:%02d", t / 3600, (t % 3600) / 60, t % 60)
                cmd = $8; for (i = 9; i <= NF; i++) cmd = cmd " " $i
                printf "%7s  %-10.10s %5s  %4s  %6s  %8s  %s\n", $1, $2, $3, $4, r, tm, cmd
              }')
  '';

  # cpu: percentage (two /proc/stat samples over a short window) + package temp,
  # tooltip = top processes by CPU.
  cpuStats = pkgs.writeShellScript "wayle-cpu-stats" ''
    ${emitJson}
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

    ${procTable "-pcpu"}

    # Threshold class on CPU load → the label goes amber/red (styles/index.scss).
    class=""
    if [ "$pct" -ge 95 ]; then class="metric-crit"; elif [ "$pct" -ge 80 ]; then class="metric-warn"; fi

    emit "$label" "$tip" "$class"
  '';

  # ram: used/total GiB from /proc/meminfo, tooltip = top processes by memory.
  ramStats = pkgs.writeShellScript "wayle-ram-stats" ''
    ${emitJson}
    ps=${pkgs.procps}/bin/ps

    # Used = Total − Available (excludes reclaimable cache/buffers, matching the
    # "used" figure most tools report).
    total_kb=$(awk '/^MemTotal:/{ print $2 }' /proc/meminfo)
    avail_kb=$(awk '/^MemAvailable:/{ print $2 }' /proc/meminfo)
    used_kb=$(( total_kb - avail_kb ))
    label=$(awk -v u="$used_kb" -v t="$total_kb" \
              'BEGIN{ printf "%.1f/%.1fG", u / 1048576, t / 1048576 }')

    ${procTable "-pmem"}

    # Threshold class on memory pressure (used / total).
    mem_pct=0
    [ "$total_kb" -gt 0 ] && mem_pct=$(( used_kb * 100 / total_kb ))
    class=""
    if [ "$mem_pct" -ge 90 ]; then class="metric-crit"; elif [ "$mem_pct" -ge 80 ]; then class="metric-warn"; fi

    emit "$label" "$tip" "$class"
  '';

  # disk: same idea for storage — %-used on / as the label, tooltip = a df table
  # of the real mounts. df is instant, so no sampling needed.
  diskStats = pkgs.writeShellScript "wayle-disk-stats" ''
    ${emitJson}
    df=${pkgs.coreutils}/bin/df

    pct=$($df --output=pcent / 2>/dev/null | awk 'NR == 2 { gsub(/[ %]/, ""); print }')
    [ -n "$pct" ] || pct=0
    label="''${pct}%"

    # Real filesystems only (drop tmpfs/overlay/etc.); MOUNT is last so long
    # mount points can't push the numeric columns out of alignment.
    tip=$($df -h --output=size,used,avail,pcent,target \
             -x tmpfs -x devtmpfs -x efivarfs -x overlay -x squashfs 2>/dev/null \
          | awk 'NR == 1 { printf "%5s %5s %5s %5s  %s\n", "SIZE", "USED", "FREE", "USE%", "MOUNT"; next }
                       { printf "%5s %5s %5s %5s  %s\n", $1, $2, $3, $4, $5 }')

    # Threshold class on / usage (fills slowly, so high cut-offs).
    class=""
    if [ "$pct" -ge 95 ]; then class="metric-crit"; elif [ "$pct" -ge 85 ]; then class="metric-warn"; fi

    emit "$label" "$tip" "$class"
  '';

  # net: down/up rate on the default-route interface as the label, tooltip = each
  # real interface with its IPv4 (docker/veth/bridge junk filtered out). Rates
  # come from two /proc/net/dev samples, like cpu.
  netStats = pkgs.writeShellScript "wayle-net-stats" ''
    ${emitJson}
    ip=${pkgs.iproute2}/bin/ip

    iface=$($ip route show default 2>/dev/null \
              | awk '{ for (i = 1; i <= NF; i++) if ($i == "dev") { print $(i + 1); exit } }')
    [ -n "$iface" ] || iface=$($ip -o link show up 2>/dev/null | awk -F': ' '$2 != "lo" { print $2; exit }')

    read_bytes() {
      awk -v ifc="$1" 'NR > 2 { gsub(/:/, " "); if ($1 == ifc) { print $2, $10; exit } }' /proc/net/dev
    }
    set -- $(read_bytes "$iface"); rx1=''${1:-0}; tx1=''${2:-0}
    sleep 0.5
    set -- $(read_bytes "$iface"); rx2=''${1:-0}; tx2=''${2:-0}
    drx=$(( (rx2 - rx1) * 2 )); dtx=$(( (tx2 - tx1) * 2 )) # ×2: 0.5 s window → per second

    fmt() {
      awk -v b="$1" 'BEGIN{ split("B K M G T", u, " "); i = 1;
        while (b >= 1024 && i < 5) { b /= 1024; i++ }
        if (i == 1) printf "%d%s", b, u[i]; else printf "%.1f%s", b, u[i] }'
    }
    label="↓$(fmt $drx) ↑$(fmt $dtx)"

    tip=$(printf '%-12s %s\n' 'IFACE' 'ADDRESS'; \
          $ip -brief -4 addr show up 2>/dev/null \
            | awk '$1 != "lo" && $1 !~ /^(docker|veth|br-|virbr)/ { printf "%-12s %s\n", $1, $3 }')

    emit "$label" "$tip" "" # no threshold on network
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
          # Floating pill: inset the bar from the screen edges so the rounded
          # corners actually show (flush against the edge they'd be clipped),
          # with a full border matching the tiled windows (border_size = 2,
          # blue accent). Insets are Wayle Spacing units (scaled em, not px) —
          # tuned so the on-screen gap ≈ Hyprland's gaps_out (8 px). NB: the
          # bar's exclusive zone grows by the inset, so the htop dropdown
          # anchor in hyprland.nix moves with it (re-tune there if changed).
          inset-edge = 0.55;
          inset-ends = 0.55;
          border-location = "all";
          border-width = 2;
          border-color = "border-accent";
          rounding = "lg";
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
          # Button shape (folded from runtime.toml). With the fills above at 0
          # these mostly affect icon/label layout and (invisible) corner rounding.
          button-variant = "basic";
          button-rounding = "lg";

          layout = [
            {
              monitor = "*";
              show = true;
              # Single Wayle bar (Wayle can't render a second). Left: workspaces
              # + current window title. Right: tray, metrics, night light, the
              # wifi/bluetooth/audio/battery cluster, date, notifications,
              # dashboard.
              left = [
                "hyprland-workspaces"
                "window-title"
              ];
              center = [ ];
              right = [
                "systray"
                # Metrics — all four are custom modules (custom-disk / custom-net
                # / custom-ram / custom-cpu) so each carries a hover tooltip that
                # Wayle's native storage/netstat/cpu/ram modules can't: disk → a
                # df table, net → interfaces + IPs, ram → top procs by memory,
                # cpu → top procs by CPU (see the *Stats scripts). Listed flat
                # rather than in a `sysmon` group: the group background is
                # transparent here (button-group-opacity = 0), so a group would be
                # visually identical, and a group's `modules` list takes native
                # names, not `custom-*` refs.
                "custom-disk"
                "custom-net"
                "custom-ram"
                "custom-cpu"
                # night light toggle (hyprsunset must be running — see packages)
                "hyprsunset"
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
          # This is independent of the Hyprland monitor scale: the compositor
          # sizes the surface, this sizes Wayle's internal layout. Bumped to 1.2
          # (folded from a live runtime.toml tweak) for a chunkier bar.
          scale = 1.2;
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
            # `display-mode = "icon"` (folded from runtime.toml) shows each
            # workspace-map ICON; ours only sets a `label` ("●"), and icon mode
            # falls back to the label when a workspace has no icon — so the dot
            # still renders, still sized by `label-size`. Colour tracks state
            # (active = accent blue, occupied = fg-muted, empty = subtle).
            display-mode = "icon";
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

          # Rainbow stops (left → right). Each placed module tints only its glyph;
          # labels stay readable `fg` via `tinted`. disk/net/cpu/ram are custom
          # modules below (for their tooltips), so they're tinted there, not here.
          volume = tinted rainbow.volume;
          network = tinted rainbow.network;
          # bluetooth: icon only (label hidden — folded from runtime.toml), so
          # the connected device name doesn't crowd the bar.
          bluetooth = (tinted rainbow.bluetooth) // { label-show = false; };

          # Night-light toggle, placed between the metrics and the status
          # cluster. Orange is its canonical hue (warm light); it sits outside
          # the rainbow proper, like battery, because its colour means
          # something. Icon only — the module has no useful label.
          hyprsunset = (tinted tn.orange) // { label-show = false; };
          # Not placed on the bar; keep a canonical TN hue for if/when it is.
          idle-inhibit = (tinted tn.yellow) // { label-show = false; };

          # disk / net / ram / cpu as custom modules (custom-disk / custom-net /
          # custom-ram / custom-cpu in the layout). Native storage/netstat/cpu/ram
          # can't show a tooltip, so each is reimplemented here: the script's JSON
          # `text` is the bar label, its `tooltip` the hover detail. cpu/ram also
          # left-click to the htop dropdown; disk/net are display-only. icon-color
          # carries the rainbow stop; the transparent chip / `fg` label match
          # `tinted`.
          custom = [
            {
              id = "disk";
              command = "${diskStats}";
              mode = "poll";
              interval-ms = 30000; # disk usage barely moves; matches native storage
              icon-name = "ld-hard-drive-symbolic";
              icon-show = true;
              icon-color = rainbow.storage;
              icon-bg-color = "transparent";
              label-show = true;
              label-color = "fg-default";
            }
            {
              id = "net";
              command = "${netStats}";
              mode = "poll";
              interval-ms = 2000; # rate readout; the script adds a 0.5 s sample window
              icon-name = "ld-activity-symbolic";
              icon-show = true;
              icon-color = rainbow.netstat;
              icon-bg-color = "transparent";
              label-show = true;
              label-color = "fg-default";
            }
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

          # Notifications: red/pink bar glyph (via `tinted`) plus popup tuning.
          # Position/duration stay on Wayle's defaults (top-right, 5 s).
          # `popup-shadow = false` drops the card's drop shadow (the soft edge
          # around each toast). `popup-urgency-bar = "none"` removes the 2 px
          # inset strip at the top of every card — for normal-urgency toasts
          # that strip is the blue accent, which reads as a stray top border.
          # `popup-margin-y` nudges the stack down from the top edge (px,
          # applied as a layer-shell top margin). The popup *width* isn't a
          # config key; it's set in styles/index.scss.
          notifications = (tinted rainbow.notifications) // {
            label-show = false; # icon only (folded from runtime.toml)
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

          # Control-center button (lock / logout / reboot / poweroff) — the far,
          # darkest end of the rainbow. Icon only; this module has no label-color
          # key, so `tinted` can't be used (it would set an unknown key) — set the
          # glyph colour directly.
          dashboard = {
            icon-color = rainbow.dashboard;
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

    // Slightly smaller popup text (~10% down from Wayle's own sizes; there is
    // no config key for popup fonts). Wayle sets each class from a --text-*
    // var, so shrink relative to the same var rather than hardcoding px:
    // title was --text-md, body was --text-base * 1.1, app/time --text-sm/xs.
    .notification-popup-title {
      font-size: calc(var(--text-md) * 0.9);
    }
    .notification-popup-body {
      font-size: var(--text-base);
    }
    .notification-popup-app {
      font-size: calc(var(--text-sm) * 0.9);
    }
    .notification-popup-time {
      font-size: calc(var(--text-xs) * 0.9);
    }

    // Monospace tooltips. The cpu/ram modules print a space-padded process
    // table in their hover tooltip; the columns only align in a fixed-width
    // font (the bar's sans is Inter). GTK tooltips are their own top-level
    // windows, but Wayle installs its stylesheet display-wide (that's how the
    // notification rule above reaches its popup), so this reaches them too.
    tooltip,
    tooltip label {
      font-family: "JetBrains Mono", monospace;
    }

    // Metric thresholds. The cpu/ram/disk scripts emit a `class` (metric-warn /
    // metric-crit) once a resource crosses its cut-off; Wayle adds it to the
    // module root, which also carries `.custom`. Colour just the numeric label —
    // the icon keeps its rainbow hue. Wayle drives label colour through a
    // per-button `--bar-btn-label-color` var set with a `* {}` rule at USER
    // priority, so specificity alone can't win here; `!important` on `color` does.
    .custom.metric-warn .bar-button-label {
      color: #e0af68 !important; // amber — warning
    }
    .custom.metric-crit .bar-button-label {
      color: #f7768e !important; // red — critical
    }
  '';
}
