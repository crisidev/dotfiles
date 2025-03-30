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
      deadnix
      delta
      fd
      fzf
      iotop
      iproute2
      git
      go
      harper
      jq
      k3sup
      k9s
      kubectl
      kubectx
      neovim
      nix-direnv
      nixfmt-rfc-style
      nodejs_22
      node2nix
      pre-commit
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
      rustup
      sops
      starship
      statix
      strace
      typescript
      uv
      yazi
      yq-go
      zoxide
      yarn
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
      username = "bigo";
      homeDirectory = "/home/bigo";
      sessionVariables = { NIX_SHELL_PRESERVE_PROMPT = 1; };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.home-manager.enable = true;
  };

  imports = [ ];
}
