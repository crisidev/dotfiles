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
    };
    home-manager.enable = true;
  };

  news.display = "silent";
}
