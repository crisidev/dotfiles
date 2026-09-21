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

  # hyprlock PAM service (/etc/pam.d/hyprlock). Password auth for the Nix
  # hyprlock, done WITHOUT dlopening any host glibc module into hyprlock's
  # process. Full rationale on the hyprlock.pam `text` below; the setgid-shadow
  # chkpwd helper it relies on is provisioned via the tmpfiles.d fragment below.
  pamSrc = "/home/${config.home.username}/.config/hyprland/hyprlock.pam";
  pamDst = "/etc/pam.d/hyprlock";

  # tmpfiles.d fragment providing the setgid-shadow unix_chkpwd that Nix's
  # pam_unix execs: the real copy lives on /usr/local (exec+suid-ok) with a
  # symlink at the hardcoded /run path, because /run here is nosuid+noexec.
  # See the full rationale on the fragment's `text` below.
  tmpfilesSrc = "/home/${config.home.username}/.config/hyprland/hyprlock-chkpwd.conf";
  tmpfilesDst = "/etc/tmpfiles.d/hyprlock-chkpwd.conf";

  # The exact commands the activation script runs, and nothing else.
  sudoRule = ''
    ${config.home.username} ALL=(root) NOPASSWD: /usr/bin/install -m644 ${sessionSrc} ${sessionDst}, /usr/bin/rm -f ${staleSession}, /usr/bin/install -m644 ${pamSrc} ${pamDst}, /usr/bin/install -m644 ${tmpfilesSrc} ${tmpfilesDst}, /usr/bin/systemd-tmpfiles --create ${tmpfilesDst}
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
      # below). hyprlock is a Nix binary linking Nix's libpam, so every module
      # named here is loaded by Nix's libpam from the Nix store.
      #
      # We use Nix's OWN pam_unix.so (absolute store path), NOT the host module.
      # History: we used to pin the host /usr/lib/.../pam_unix.so because Nix's
      # pam_unix couldn't reach a setgid unix_chkpwd (its Nix helper isn't
      # setgid, so it can't read /etc/shadow). That worked until the host glibc
      # was upgraded to 2.43: the host module then required GLIBC_2.43 symbols,
      # but hyprlock runs with Nix glibc 2.42 in-process, so dlopen'ing the host
      # module failed ("version `GLIBC_2.43' not found") and every password was
      # rejected. nixpkgs still ships glibc 2.42, so bumping it can't fix this —
      # the host got AHEAD of nixpkgs.
      #
      # Fix: keep the module Nix (loads cleanly against Nix glibc) and give Nix's
      # pam_unix a working helper. Nix's pam_unix execs /run/wrappers/bin/
      # unix_chkpwd (a path baked into the module); we provision that as a
      # setgid-shadow COPY of Nix's own version-matched unix_chkpwd via tmpfiles.d
      # (see hyprlock-chkpwd.conf below). The helper runs as a SEPARATE process
      # with its own Nix glibc, so there is no in-process ABI mixing — this is
      # immune to future host glibc upgrades.
      #
      # account uses pam_permit: a personal lockscreen needs no account aging or
      # expiry checks, and this keeps the account phase off the shadow file.
      file.".config/hyprland/hyprlock.pam".text = ''
        auth      required   ${pkgs.linux-pam}/lib/security/pam_unix.so
        account   required   ${pkgs.linux-pam}/lib/security/pam_permit.so
      '';

      # tmpfiles.d fragment providing the setgid-shadow unix_chkpwd that Nix's
      # pam_unix.so (above) execs at the hardcoded path /run/wrappers/bin/
      # unix_chkpwd to read /etc/shadow.
      #
      # /run here is mounted nosuid,noexec (hardened Ubuntu), so a setgid binary
      # placed directly under /run can be neither executed nor honour its setgid
      # bit — pam_unix's exec of it fails with EACCES. So we keep the REAL helper
      # on / (exec+suid-ok): a setgid-shadow COPY of Nix's OWN version-matched
      # unix_chkpwd at /usr/local/lib/hyprlock, and put only a SYMLINK at the
      # hardcoded /run path. execve() follows the symlink and applies the TARGET's
      # mount flags, so /run's nosuid/noexec don't apply — the copy on / runs
      # setgid and reads shadow. (This is what NixOS's dedicated /run/wrappers
      # exec+suid tmpfs achieves; the symlink is the non-NixOS equivalent.)
      #
      # Version-matched because ${pkgs.linux-pam} is byte-for-byte the linux-pam
      # hyprlock links. `C+` force-replaces the copy so a linux-pam bump refreshes
      # it; `z` pins the setgid bit + shadow group; `L+` recreates the /run symlink
      # on every boot (/run is tmpfs) and switch.
      file.".config/hyprland/hyprlock-chkpwd.conf".text = ''
        d /usr/local/lib/hyprlock 0755 root root -
        C+ /usr/local/lib/hyprlock/unix_chkpwd 2755 root shadow - ${pkgs.linux-pam}/bin/unix_chkpwd
        z /usr/local/lib/hyprlock/unix_chkpwd 2755 root shadow -
        d /run/wrappers 0755 root root -
        d /run/wrappers/bin 0755 root root -
        L+ /run/wrappers/bin/unix_chkpwd - - - - /usr/local/lib/hyprlock/unix_chkpwd
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

      # Provision the setgid-shadow unix_chkpwd helper (copy on /usr/local +
      # symlink at the hardcoded /run/wrappers path) via the tmpfiles.d fragment
      # above. Installs the fragment as root and applies it immediately with
      # `systemd-tmpfiles --create`; on boot systemd-tmpfiles-setup replays it
      # (recreating the /run symlink, since /run is tmpfs). Same sudo -n +
      # NOPASSWD mechanism as the installs above — note the sudoers rule grew, so
      # it must be re-installed once before this can run non-interactively.
      activation.installHyprlockChkpwd = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        tsrc=${tmpfilesSrc}
        tdst=${tmpfilesDst}
        if ! ${pkgs.diffutils}/bin/cmp -s "$tsrc" "$tdst"; then
          if $DRY_RUN_CMD /usr/bin/sudo -n /usr/bin/install -m644 "$tsrc" "$tdst" 2>/dev/null; then
            $DRY_RUN_CMD /usr/bin/sudo -n /usr/bin/systemd-tmpfiles --create "$tdst" 2>/dev/null \
              || echo "NOTE: installed $tdst but 'systemd-tmpfiles --create' failed; it applies on next boot." >&2
            echo "Installed hyprlock chkpwd helper -> $tdst"
          else
            echo "NOTE: couldn't auto-install the hyprlock chkpwd helper (needs root)." >&2
            echo "      Re-install the (now-extended) sudoers rule once:" >&2
            echo "        sudo install -m440 -o root -g root ~/.config/hyprland/gdm-session.sudoers /etc/sudoers.d/50-hyprland-gdm-session" >&2
            echo "      Or install it now by hand:" >&2
            echo "        sudo install -m644 $tsrc $tdst && sudo systemd-tmpfiles --create $tdst" >&2
          fi
        fi
      '';

      extraOutputsToInstall = [ "dev" ];
    };

    programs.direnv.enableZshIntegration = true;
  };
}
