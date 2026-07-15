{ ... }:
{
  # GitHub CLI — ported 1:1 from home/.config/gh/config.yml. home-manager renders
  # settings → ~/.config/gh/config.yml (version = "1" is added automatically).
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "nvim";
      prompt = "enabled";
      pager = "bat --paging=always --color=always --style=plain";
      aliases = {
        co = "pr checkout";
        rc = "repo clone";
        repo-delete = ''api -X DELETE "repos/$1"'';
        fork = "repo fork --remote-name=fork --remote=true";
      };
    };
  };
}
