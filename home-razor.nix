{ lib, pkgs, ... }: {
  imports = [ ./home-nix-razor ];

  config = {
    targets.genericLinux.enable = true;

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = [ "nix-2.16.2" ];
      };
    };

    home = {
      stateVersion = "24.11";
      username = "root";
      homeDirectory = "/root";
    };

    home.sessionVariables = { NIX_SHELL_PRESERVE_PROMPT = 1; };

    # Enable direnv
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Allow home-manager to manage itself
    programs.home-manager.enable = true;
  };
}
