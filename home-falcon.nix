{ lib, pkgs, ... }: {
  imports = [ ./home-nix-falcon ];

  config = {
    targets.genericLinux.enable = true;

    nixGLPrefixIntel = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";
    # These two lines make the flake impure
    # nixGLPrefixAuto = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL";
    # nixGLPrefixNvidia = "${pkgs.nixgl.auto.nixGLNvidia}/bin/nixGLNvidia-560.35.03";
    nixGLPrefixNvidia = "";

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = [ "nix-2.16.2" ];
      };
    };

    home = {
      stateVersion = "24.11";
      username = "bigo";
      homeDirectory = "/home/bigo/";
    };

    home.sessionVariables = { NIX_SHELL_PRESERVE_PROMPT = 1; };

    # Enable direnv
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Allow home-manager to manage itself
    programs.home-manager.enable = true;

    home.activation.updateNeovim = lib.mkAfter ''
      $HOME/.cargo/bin/bob update
    '';

    home.activation.updateGsettings = lib.mkAfter ''
      $HOME/.bin/gsettings-update
    '';
  };
}
