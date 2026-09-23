{ lib, config, ... }:
{
  # k9s — ported from the hand-managed ~/.config/k9s. home-manager renders
  # settings → config.yaml and aliases → aliases.yaml. No skin is set (the old
  # config never selected one), and `skins` is deliberately left empty: when it
  # is non-empty and ui.skin is unset, home-manager auto-selects the first skin.
  programs.k9s = {
    enable = true;
    settings.k9s = {
      liveViewAutoRefresh = false;
      screenDumpDir = "${config.xdg.stateHome}/k9s/screen-dumps";
      refreshRate = 2;
      maxConnRetry = 5;
      readOnly = false;
      noExitOnCtrlC = false;
      portForwardAddress = "localhost";
      ui = {
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
