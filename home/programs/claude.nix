{ lib, config, ... }:
let
  claudeDir = ../claude;
  repoClaudeDir = "${lib.removeSuffix "/" config.home.homeDirectory}/.homesick/repos/dotfiles/home/claude";
  inherit (config.programs.claude-code) configDir;
in
{
  programs.claude-code = {
    enable = true;
    # Claude Code uses its native self-updating install (~/.local/bin/claude);
    # the nixpkgs build lags behind and would shadow it in PATH.
    package = null;
    # Pulls in RTK.md, which `rtk init` writes and keeps up to date itself.
    context = claudeDir + "/CLAUDE.md";
  };

  home.file = {
    "${configDir}/CLAUDE.md".force = true;
    # Claude Code writes to settings.json (/model, /config, plugins, permission
    # grants), so link it to the repo copy instead of a read-only store path.
    "${configDir}/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoClaudeDir}/settings.json";
      force = true;
    };
  };

  # Linked to the repo copy too: claude-powerline reloads its config on change,
  # so edits apply without a switch.
  xdg.configFile."claude-powerline/config.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${repoClaudeDir}/powerline.json";
    force = true;
  };
}
