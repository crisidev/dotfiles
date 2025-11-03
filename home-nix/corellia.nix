{ pkgs, ... }: {
  config = {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      antidote
      awscli2
      bat
      btop
      curl
      direnv
      eza
      deadnix
      delta
      dig
      fd
      fzf
      iotop
      iproute2
      git
      go
      gotify-cli
      harper
      htop
      jq
      k3sup
      k9s
      kubectl
      kubectx
      kubernetes-helm
      mosh
      neovim
      nix-direnv
      nixfmt-rfc-style
      nodejs_22
      node2nix
      pgloader
      powertop
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
      rclone
      ripgrep
      rustup
      sops
      starship
      statix
      strace
      tmux
      tokei
      typescript
      uv
      wget
      yazi
      yq-go
      zsh
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
