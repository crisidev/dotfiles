{
  pkgs,
  config,
  lib,
  ...
}:
let
  home = lib.removeSuffix "/" config.home.homeDirectory;
in
{
  # XDG user directories — ported from home/.config/user-dirs.dirs. Most point at
  # $HOME (no separate Desktop/Templates/Music/… folders).
  xdg.userDirs = {
    enable = true;
    # The old homesick user-dirs.dirs only wrote the file; it never exported
    # XDG_*_DIR into the environment. Keep that (and silence the stateVersion
    # default-change warning) by not setting session variables.
    setSessionVariables = false;
    desktop = home;
    download = "${home}/Downloads";
    templates = home;
    publicShare = home;
    documents = "${home}/Documents";
    music = home;
    pictures = "${home}/Pictures";
    videos = home;
  };

  # Small standalone config files with no dedicated home-manager module.
  xdg.configFile = {
    # bob (neovim version manager)
    "bob/config.json".source =
      (pkgs.formats.json { }).generate "bob-config.json" {
        add_neovim_binary_to_path = false;
        ignore_running_instances = true;
      };

    # markdownlint-cli2 (used by the nvim markdown tooling)
    "markdownlint-cli2.yaml".text = ''
      config:
        MD013: false
    '';

    # Slack sidebar theme colours (TokyoNight). NOTE: reference only — Slack isn't
    # installed and doesn't read this path; kept as the palette note it always was.
    "Slack/theme".text = "#292E42, #7AA2F7, #9ECE6A, #9ECE6A\n";
  };

  # Custom .desktop launchers (ported from home/.local/share/applications). The
  # redundant per-locale Name/Comment/Keywords lines from the old files are dropped
  # (they were identical to the base). The two flatpak-launch overrides
  # (Signal, Bitwarden) are handled with the flatpak overrides, not here.
  xdg.desktopEntries = {
    kitty = {
      name = "kitty";
      genericName = "Terminal emulator";
      comment = "Fast, feature-rich, GPU based terminal";
      icon = "/home/bigo/.icons/Suru++/apps/scalable/kitty.svg";
      exec = "/home/bigo/.nix-profile/bin/kitty";
      terminal = false;
      type = "Application";
      categories = [
        "System"
        "TerminalEmulator"
      ];
      startupNotify = true;
      settings = {
        Version = "1.0";
        TryExec = "/home/bigo/.nix-profile/bin/kitty";
      };
    };

    kitty-open = {
      name = "kitty URL Launcher";
      genericName = "Terminal emulator";
      comment = "Open URLs with kitty";
      icon = "/home/bigo/.icons/Suru++/apps/scalable/kitty.svg";
      exec = "/home/bigo/.nix-profile/bin/kitty +open %U";
      terminal = false;
      type = "Application";
      categories = [
        "System"
        "TerminalEmulator"
      ];
      mimeType = [
        "image/*"
        "application/x-sh"
        "application/x-shellscript"
        "inode/directory"
        "text/*"
        "x-scheme-handler/kitty"
        "x-scheme-handler/ssh"
      ];
      startupNotify = true;
      noDisplay = true;
      settings = {
        Version = "1.0";
        TryExec = "/home/bigo/.nix-profile/bin/kitty";
      };
    };
  };
}
