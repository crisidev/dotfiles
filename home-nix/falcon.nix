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
    ./programs/wayle.nix
    ./programs/lazygit.nix
    ./programs/kitty.nix
    ./programs/zellij.nix
  ];

  config = {
    home.packages = with pkgs; [
      age
      ansible
      antidote
      argocd
      aseprite
      awscli2
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
      kubectl
      kubectx
      kubernetes-helm
      kyverno
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
      topgrade
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
      # activation.updateGsettings = lib.mkAfter ''
      #   $HOME/.bin/gsettings-update
      # '';

      # Register the Hyprland session with GDM. GDM (running as the gdm user)
      # only reads /usr/share/wayland-sessions/, which home-manager (running as
      # bigo) can't write — so this copies the generated .desktop there via sudo.
      # We copy rather than symlink so gdm never has to traverse ~/.local into
      # /nix/store. The cmp guard means sudo only runs (and only prompts for a
      # password) when the file actually changed or the stale hyprland-nix.desktop
      # is still present, so routine rebuilds stay silent and non-interactive.
      # If sudo is unavailable (e.g. non-interactive rebuild), we warn instead of
      # aborting the whole switch — re-run the copy by hand from the README.
      activation.installHyprlandSession = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        src=${config.home.file.".local/share/wayland-sessions/hyprland.desktop".source}
        dst=/usr/share/wayland-sessions/hyprland.desktop
        stale=/usr/share/wayland-sessions/hyprland-nix.desktop
        if ! ${pkgs.diffutils}/bin/cmp -s "$src" "$dst" || [ -e "$stale" ]; then
          run() { $DRY_RUN_CMD /usr/bin/sudo -n "$@" 2>/dev/null || $DRY_RUN_CMD /usr/bin/sudo "$@"; }
          if run ${pkgs.coreutils}/bin/install -Dm644 "$src" "$dst"; then
            run ${pkgs.coreutils}/bin/rm -f "$stale"
            echo "Installed Hyprland GDM session -> $dst"
          else
            echo "WARNING: could not sudo-install $dst; register it manually (see README)." >&2
          fi
        fi
      '';

      extraOutputsToInstall = [ "dev" ];
    };

    programs.direnv.enableZshIntegration = true;
  };
}
