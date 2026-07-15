{ pkgs, ... }:
{
  imports = [
    ./programs/starship.nix
    ./programs/git.nix
    ./programs/bat.nix
    ./programs/yazi.nix
    ./programs/zsh.nix
    ./programs/scripts.nix
  ];

  # Shell tooling wired by hand into programs/zsh's init (via _evalcache + `which`
  # guards), rather than through their home-manager modules:
  #   carapace       multi-shell completions for 1000+ CLIs
  #   pay-respects   `f` reruns a corrected version of the last command
  #   comma          `,` runs any nixpkgs binary without installing it
  #   nix-index      builds the file DB comma reads (run `nix-index` once per host)
  home.packages = with pkgs; [
    carapace
    pay-respects
    comma
    nix-index
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
