{
  lib,
  pkgs,
  config,
  ...
}:
let
  nixGL = import ./nixGL.nix { inherit pkgs config; };
in
{
  config = {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      age
      antidote
      awscli2
      bat
      btop
      brightnessctl
      clang_19
      cmake
      curl
      deadnix
      delta
      direnv
      eza
      fd
      feh
      figlet
      file
      font-awesome
      fzf
      gh
      (nixGL pkgs.ghostty)
      git
      # gitui
      glab
      glibc
      glow
      go
      heaptrack
      htop
      hwinfo
      hyfetch
      hyperfine
      iotop
      imagemagick
      (nixGL pkgs.kitty)
      jdk
      jq
      just
      k3sup
      k9s
      kubectl
      kubectx
      kubernetes-helm
      kyverno
      lazygit
      ltrace
      lua51Packages.lua
      luarocks
      mergiraf
      meson
      mkdocs
      mosh
      minikube
      minio-client
      neofetch
      nerd-fonts.symbols-only
      ninja
      nixgl.auto.nixGLDefault
      #nixgl.auto.nixGLNvidia
      nixgl.nixGLIntel
      nixfmt-rfc-style
      nix-direnv
      nix-output-monitor
      openssl
      pkg-config
      poppler
      redis
      ripgrep
      scaleway-cli
      silicon
      sops
      # (spotify-player.override {
      #   withAudioBackend = "pulseaudio";
      #   withStreaming = true;
      #   withDaemon = true;
      #   withMediaControl = true;
      #   withImage = true;
      #   withNotify = true;
      #   withSixel = true;
      #   withFuzzy = true;
      # })
      starship
      statix
      strace
      tokei
      topgrade
      trunk
      tzupdate
      valgrind
      wev
      which
      yazi
      ydotool
      yq-go
      zellij
      zenith
      zoxide
      zstd
    ];

    targets.genericLinux.enable = true;

    nixGLPrefixIntel = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";
    # Uncomment if needed:
    # nixGLPrefixAuto = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL";
    # nixGLPrefixNvidia = "${pkgs.nixgl.auto.nixGLNvidia}/bin/nixGLNvidia-560.35.03";
    # nixGLPrefixNvidia = "";

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

    home = {
      stateVersion = "24.11";
      username = "bigo";
      homeDirectory = "/home/bigo/";
      sessionVariables = {
        NIX_SHELL_PRESERVE_PROMPT = 1;
      };
      activation.updateNeovim = lib.mkAfter ''
        $HOME/.cargo/bin/bob update
      '';
      activation.updateGsettings = lib.mkAfter ''
        $HOME/.bin/gsettings-update
      '';
      extraOutputsToInstall = [ "dev" ];
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.home-manager.enable = true;
  };

  imports = [
    ./options.nix
    ./programs/rust.nix
    ./programs/python.nix
    ./programs/node.nix
    ./programs/zathura.nix
  ];
}
