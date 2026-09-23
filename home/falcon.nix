{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./common.nix
    ./options.nix
    ./programs/flatpak.nix
    ./programs/fonts.nix
    ./programs/gh.nix
    ./programs/ghostty.nix
    ./programs/gnome.nix
    ./programs/gpg.nix
    ./programs/k9s.nix
    ./programs/kitty.nix
    ./programs/lazygit.nix
    ./programs/mimeapps.nix
    ./programs/node.nix
    ./programs/python.nix
    ./programs/qt.nix
    ./programs/rust.nix
    ./programs/topgrade.nix
    ./programs/xdg-config.nix
    ./programs/zathura.nix
    ./programs/zellij.nix
  ];

  config = {
    home.packages = with pkgs; [
      age
      ansible
      argocd
      aseprite
      awscli2
      brightnessctl
      btop
      clang_19
      cmake
      cmctl
      curl
      d2
      deadnix
      delta
      direnv
      eza
      fastfetch
      fd
      feh
      figlet
      file
      font-awesome
      fzf
      glab
      glibc
      glow
      go
      heaptrack
      htop
      hwinfo
      hyfetch
      hyperfine
      imagemagick
      iotop
      jdk
      jq
      just
      k3sup
      kubectl
      kubectl-cnpg
      kubectx
      kubernetes-helm
      kyverno
      lua51Packages.lua
      luarocks
      mash
      mergiraf
      meson
      minio-client
      mkdocs
      mosh
      nerd-fonts.symbols-only
      nix-direnv
      nix-output-monitor
      nixd
      nixfmt
      nixgl.auto.nixGLDefault
      nixgl.nixGLIntel
      ninja
      openssl
      opencode
      pkg-config
      poppler
      protobuf
      redis
      ripgrep
      ruby
      rubyPackages.rails
      scaleway-cli
      socat
      sops
      statix
      stern
      strace
      tokei
      trunk
      tzupdate
      valgrind
      wev
      which
      yamllint
      ydotool
      yq-go
      zenith
      zoxide
      zstd
    ];

    nixGLPrefixIntel = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";
    # nixGLPrefixAuto = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL";
    # nixGLPrefixNvidia = "${pkgs.nixgl.auto.nixGLNvidia}/bin/nixGLNvidia-560.35.03";

    home = {
      username = "bigo";
      homeDirectory = "/home/bigo/";
      sessionVariables = {
        PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig:$PKG_CONFIG_PATH";
        OPENSSL_DIR = "${pkgs.openssl.dev}";
        OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
        OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
        UV_HTTP_TIMEOUT = "600";
        NIXPKGS_ALLOW_UNFREE = "1";
      };
      file.".local/bin/uv".source = "${pkgs.uv}/bin/uv";
      activation.updateNeovim = lib.mkAfter ''
        $HOME/.cargo/bin/bob update
      '';
      extraOutputsToInstall = [ "dev" ];
    };

    programs.direnv.enableZshIntegration = true;
  };
}
