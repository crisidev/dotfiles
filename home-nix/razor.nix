{ pkgs, ... }: {
  config = {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      antidote
      awscli2
      bat
      curl
      direnv
      eza
      delta
      fd
      fzf
      git
      jq
      neovim
      nix-direnv
      nixfmt-rfc-style
      (python312.withPackages (p:
        with p; [
          black
          boto3
          boto3-stubs
          ipython
          isort
          pip
          pynvim
          pytest
          virtualenv
          numpy
        ]))
      ripgrep
      starship
      strace
      uv
      yazi
      yq
      zoxide
    ];

    targets.genericLinux.enable = true;

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

    home = {
      stateVersion = "24.11";
      username = "root";
      homeDirectory = "/root";
      sessionVariables = { NIX_SHELL_PRESERVE_PROMPT = 1; };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.home-manager.enable = true;
  };

  imports = [];
}
