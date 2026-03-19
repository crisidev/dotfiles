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
  imports = [
    ./common.nix
    ./options.nix
    ./programs/rust.nix
    ./programs/python.nix
    ./programs/node.nix
    ./programs/zathura.nix
    ./programs/hyprland.nix
  ];

  config = {
    home.packages = with pkgs; [
      age
      ansible
      antidote
      awscli2
      bat
      brightnessctl
      btop
      clang_19
      cmake
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
      gh
      (nixGL pkgs.ghostty)
      git
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
      k9s
      (nixGL pkgs.kitty)
      kubectl
      kubectx
      kubernetes-helm
      kyverno
      lazygit
      lua51Packages.lua
      luarocks
      mash
      mergiraf
      meson
      minikube
      minio-client
      mkdocs
      mosh
      nerd-fonts.symbols-only
      nix-direnv
      nix-output-monitor
      nixfmt
      nixgl.auto.nixGLDefault
      nixgl.nixGLIntel
      ninja
      openssl
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
      starship
      statix
      stern
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
      };
      file.".local/bin/uv".source = "${pkgs.uv}/bin/uv";
      activation.updateNeovim = lib.mkAfter ''
        $HOME/.cargo/bin/bob update
      '';
      activation.updateGsettings = lib.mkAfter ''
        $HOME/.bin/gsettings-update
      '';
      # GDM (runs as gdm user) only reads /usr/share/wayland-sessions/.
      # Copy rather than symlink so gdm doesn't need to traverse ~/.local -> /nix/store.
      # To register the Hyprland session with GDM, run once after switch:
      # sudo cp -L ~/.local/share/wayland-sessions/hyprland.desktop /usr/share/wayland-sessions/hyprland.desktop
      extraOutputsToInstall = [ "dev" ];
    };

    programs.direnv.enableZshIntegration = true;
  };
}
