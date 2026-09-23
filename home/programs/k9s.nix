{ lib, config, ... }:
let
  c = config.theme.palette.colors;
  bg = "default"; # terminal background, so kitty's translucency shows through
in
{
  # k9s — ported from the hand-managed ~/.config/k9s. home-manager renders
  # settings → config.yaml, aliases → aliases.yaml and skins → skins/*.yaml.
  programs.k9s = {
    enable = true;
    # Tokyo Night Storm skin built from the shared palette (home/theme).
    skins.tokyonight = {
      k9s = {
        body = {
          fgColor = c.fg;
          bgColor = bg;
          logoColor = c.blue;
        };
        prompt = {
          fgColor = c.fg;
          bgColor = bg;
          suggestColor = c.comment;
        };
        info = {
          fgColor = c.magenta;
          sectionColor = c.fg;
        };
        dialog = {
          fgColor = c.fg;
          bgColor = bg;
          buttonFgColor = c.bg;
          buttonBgColor = c.magenta;
          buttonFocusFgColor = c.bg;
          buttonFocusBgColor = c.blue;
          labelFgColor = c.orange;
          fieldFgColor = c.fg;
        };
        frame = {
          border = {
            fgColor = c.fgGutter;
            focusColor = c.blue;
          };
          menu = {
            fgColor = c.fg;
            keyColor = c.magenta;
            numKeyColor = c.magenta;
          };
          crumbs = {
            fgColor = c.bg;
            bgColor = c.blue0;
            activeColor = c.blue;
          };
          status = {
            newColor = c.cyan;
            modifyColor = c.magenta;
            addColor = c.green;
            pendingColor = c.orange;
            errorColor = c.red;
            highlightColor = c.yellow;
            killColor = c.comment;
            completedColor = c.comment;
          };
          title = {
            fgColor = c.fg;
            bgColor = bg;
            highlightColor = c.blue;
            counterColor = c.magenta;
            filterColor = c.green;
          };
        };
        views = {
          charts = {
            bgColor = bg;
            defaultDialColors = [
              c.blue
              c.red
            ];
            defaultChartColors = [
              c.blue
              c.red
            ];
          };
          table = {
            fgColor = c.fg;
            bgColor = bg;
            cursorFgColor = c.fg;
            cursorBgColor = c.bgVisual;
            markColor = c.yellow;
            header = {
              fgColor = c.blue;
              bgColor = bg;
              sorterColor = c.cyan;
            };
          };
          xray = {
            fgColor = c.fg;
            bgColor = bg;
            cursorColor = c.bgVisual;
            graphicColor = c.blue;
            showIcons = false;
          };
          yaml = {
            keyColor = c.blue;
            colonColor = c.comment;
            valueColor = c.fg;
          };
          logs = {
            fgColor = c.fg;
            bgColor = bg;
            indicator = {
              fgColor = c.blue;
              bgColor = bg;
            };
          };
        };
      };
    };
    settings.k9s = {
      liveViewAutoRefresh = false;
      screenDumpDir = "${lib.removeSuffix "/" config.home.homeDirectory}/.local/state/k9s/screen-dumps";
      refreshRate = 2;
      maxConnRetry = 5;
      readOnly = false;
      noExitOnCtrlC = false;
      portForwardAddress = "localhost";
      ui = {
        skin = "tokyonight";
        enableMouse = false;
        headless = false;
        logoless = false;
        crumbsless = false;
        reactive = false;
        noIcons = false;
        defaultsToFullScreen = false;
      };
      skipLatestRevCheck = false;
      disablePodCounting = false;
      shellPod = {
        image = "busybox:1.35.0";
        namespace = "default";
        limits = {
          cpu = "100m";
          memory = "100Mi";
        };
      };
      imageScans = {
        enable = false;
        exclusions = {
          namespaces = [ ];
          labels = { };
        };
      };
      logger = {
        tail = 100;
        buffer = 5000;
        sinceSeconds = -1;
        textWrap = false;
        disableAutoscroll = false;
        showTime = false;
      };
      thresholds = {
        cpu = {
          critical = 90;
          warn = 70;
        };
        memory = {
          critical = 90;
          warn = 70;
        };
      };
    };
    aliases = {
      dp = "deployments";
      sec = "v1/secrets";
      jo = "jobs";
      cr = "clusterroles";
      crb = "clusterrolebindings";
      ro = "roles";
      rb = "rolebindings";
      np = "networkpolicies";
    };
  };

  # Plugins stay as standalone YAML files (k9s merges everything under
  # plugins/) so their inline shell scripts and comments survive, instead of
  # being flattened into a single generated plugins.yaml.
  xdg.configFile = lib.mapAttrs' (
    name: _: lib.nameValuePair "k9s/plugins/${name}" { source = ../files/k9s/plugins/${name}; }
  ) (builtins.readDir ../files/k9s/plugins);
}
