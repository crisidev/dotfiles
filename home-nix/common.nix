{ ... }:
{
  imports = [
    ./programs/starship.nix
    ./programs/git.nix
    ./programs/bat.nix
    ./programs/yazi.nix
  ];

  fonts.fontconfig.enable = true;
  targets.genericLinux.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  home = {
    stateVersion = "24.11";
    sessionVariables.NIX_SHELL_PRESERVE_PROMPT = 1;
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      # Ported from the old homesick direnvrc-git-crisidev: `use git_crisidev` in an
      # .envrc sets the git author/committer to the crisidev identity.
      stdlib = ''
        use_git_crisidev() {
          export GIT_AUTHOR_EMAIL=bigo@crisidev.org
          export GIT_AUTHOR_NAME="Matteo Bigoi"
          export GIT_COMMITTER_EMAIL=bigo@crisidev.org
          export GIT_COMMITTER_NAME="Matteo Bigoi"
        }
      '';
    };
    home-manager.enable = true;
  };

  news.display = "silent";
}
