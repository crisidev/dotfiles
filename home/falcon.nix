{
  lib,
  pkgs,
  config,
  ...
}:
let
  nixGL = import ./nixGL.nix { inherit pkgs config; };

  # GDM session registration paths. Kept as stable ~/.local + system paths (no
  # /nix/store) so both the copy command and the NOPASSWD sudoers rule that
  # authorises it match byte-for-byte across rebuilds.
  sessionSrc = "/home/${config.home.username}/.local/share/wayland-sessions/hyprland.desktop";
  sessionDst = "/usr/share/wayland-sessions/hyprland.desktop";
  staleSession = "/usr/share/wayland-sessions/hyprland-nix.desktop";

  # hyprlock PAM service. Without /etc/pam.d/hyprlock, PAM falls through to
  # /etc/pam.d/other → common-auth, whose FIRST module is pam_fprintd — it
  # blocks on the reader and swallows the typed password, so password unlock
  # always fails (fingerprint still works, via hyprlock's own fprintd path).
  # This dedicated service is password-only; fingerprint is unaffected because
  # hyprlock talks to fprintd directly, not through this stack.
  pamSrc = "/home/${config.home.username}/.config/hyprland/hyprlock.pam";
  pamDst = "/etc/pam.d/hyprlock";

  # The exact commands the activation script runs, and nothing else.
  sudoRule = ''
    ${config.home.username} ALL=(root) NOPASSWD: /usr/bin/install -m644 ${sessionSrc} ${sessionDst}, /usr/bin/rm -f ${staleSession}, /usr/bin/install -m644 ${pamSrc} ${pamDst}
  '';
in
{
  imports = [
    ./common.nix
    ./options.nix
    ./programs/flatpak.nix
    ./programs/gh.nix
    ./programs/ghostty.nix
    ./programs/gpg.nix
    ./programs/hyprland.nix
    ./programs/kitty.nix
    ./programs/lazygit.nix
    ./programs/mimeapps.nix
    ./programs/node.nix
    ./programs/python.nix
    ./programs/qt.nix
    ./programs/rust.nix
    ./programs/topgrade.nix
    ./programs/wayle.nix
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
      nixd
      nixfmt
      nixfmt-rfc-style
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
      # Reproducible copy of the NOPASSWD sudoers rule that authorises the
      # activation script below. Install it once (see README / the activation's
      # own hint) with:
      #   sudo install -m440 -o root -g root \
      #     ~/.config/hyprland/gdm-session.sudoers /etc/sudoers.d/50-hyprland-gdm-session
      file.".config/hyprland/gdm-session.sudoers".text = sudoRule;

      # Reproducible source for /etc/pam.d/hyprlock (installed by the activation
      # below). Two deliberate choices:
      #
      #  1. Password-only — do NOT `@include common-auth`, whose pam_fprintd
      #     runs first and blocks the typed password. hyprlock's own fprintd
      #     integration (auth.fingerprint in hyprland.nix) still gives
      #     fingerprint unlock, independent of this stack.
      #
      #  2. ABSOLUTE path to the SYSTEM pam_unix.so, not a bare `pam_unix.so`.
      #     hyprlock is the nixpkgs build and links nix's libpam, which would
      #     otherwise load nix's pam_unix + nix's unix_chkpwd helper — and that
      #     helper is neither setuid nor setgid-shadow here, so it can't read
      #     /etc/shadow and every password is rejected. The system module at
      #     this path execs Debian's setgid-shadow /usr/sbin/unix_chkpwd, which
      #     can. (Debian/Ubuntu x86_64 multiarch path; this file is host-specific.)
      #
      #     Loading this host module also needs the host libcrypt.so.1, which the
      #     Nix hyprlock loader can't resolve on its own — the hyprlockCmd shim in
      #     programs/hyprland.nix exposes it via a scoped LD_LIBRARY_PATH. Without
      #     that shim this module fails to dlopen and every password is rejected.
      #
      #  3. No `try_first_pass`: it tells pam_unix to reuse a token from an
      #     earlier auth module, but this is the only one — so it's meaningless
      #     here. Plain `required` prompts through hyprlock's PAM conversation.
      file.".config/hyprland/hyprlock.pam".text = ''
        auth      required   /usr/lib/x86_64-linux-gnu/security/pam_unix.so
        account   required   /usr/lib/x86_64-linux-gnu/security/pam_unix.so
      '';
      activation.updateNeovim = lib.mkAfter ''
        $HOME/.cargo/bin/bob update
      '';
      # activation.updateGsettings = lib.mkAfter ''
      #   $HOME/.bin/gsettings-update
      # '';

      # Register the Hyprland session with GDM. GDM (running as the gdm user)
      # only reads /usr/share/wayland-sessions/, which home-manager (running as
      # bigo) can't write — so this copies the generated .desktop there as root.
      # We copy rather than symlink so gdm never has to traverse ~/.local into
      # /nix/store, and the cmp guard means the root commands only run when the
      # file actually changed or the stale hyprland-nix.desktop is still present.
      #
      # Activation has no controlling TTY, so an interactive sudo password prompt
      # can't work here — we use `sudo -n` (non-interactive) and rely on the
      # one-time NOPASSWD sudoers rule above. The src/dst paths are the stable
      # ~/.local + system paths (not /nix/store) precisely so they match that
      # rule byte-for-byte. If the rule isn't installed, `sudo -n` fails and we
      # print how to fix it instead of aborting the switch.
      activation.installHyprlandSession = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        src=${sessionSrc}
        dst=${sessionDst}
        stale=${staleSession}
        if ! ${pkgs.diffutils}/bin/cmp -s "$src" "$dst" || [ -e "$stale" ]; then
          if $DRY_RUN_CMD /usr/bin/sudo -n /usr/bin/install -m644 "$src" "$dst" 2>/dev/null; then
            $DRY_RUN_CMD /usr/bin/sudo -n /usr/bin/rm -f "$stale" 2>/dev/null || true
            echo "Registered Hyprland GDM session -> $dst"
          else
            echo "NOTE: couldn't auto-register the Hyprland GDM session (needs root)." >&2
            echo "      One-time setup to automate it on every switch:" >&2
            echo "        sudo install -m440 -o root -g root ~/.config/hyprland/gdm-session.sudoers /etc/sudoers.d/50-hyprland-gdm-session" >&2
            echo "      Or register it now by hand:" >&2
            echo "        sudo install -m644 $src $dst && sudo rm -f $stale" >&2
          fi
        fi
      '';

      # Install /etc/pam.d/hyprlock (root-owned) via the same sudo -n mechanism
      # and NOPASSWD rule as the GDM session above. Only runs when the file
      # differs. Without it, password unlock at the lockscreen fails.
      activation.installHyprlockPam = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        psrc=${pamSrc}
        pdst=${pamDst}
        if ! ${pkgs.diffutils}/bin/cmp -s "$psrc" "$pdst"; then
          if $DRY_RUN_CMD /usr/bin/sudo -n /usr/bin/install -m644 "$psrc" "$pdst" 2>/dev/null; then
            echo "Installed hyprlock PAM service -> $pdst"
          else
            echo "NOTE: couldn't auto-install the hyprlock PAM service (needs root)." >&2
            echo "      Re-install the (now-extended) sudoers rule once:" >&2
            echo "        sudo install -m440 -o root -g root ~/.config/hyprland/gdm-session.sudoers /etc/sudoers.d/50-hyprland-gdm-session" >&2
            echo "      Or install it now by hand:" >&2
            echo "        sudo install -m644 $psrc $pdst" >&2
          fi
        fi
      '';

      extraOutputsToInstall = [ "dev" ];
    };

    programs.direnv.enableZshIntegration = true;
  };
}
