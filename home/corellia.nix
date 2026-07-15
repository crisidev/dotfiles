{ pkgs, ... }:
{
  imports = [
    ./common.nix
    ./programs/python-base.nix
    ./programs/node.nix
    ./programs/zellij.nix
    ./programs/tmux.nix
  ];

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
    extraOutputsToInstall = [ "dev" ];
  };

  programs.direnv.enableZshIntegration = true;

  home.packages = with pkgs; [
    argocd
    awscli2
    btop
    curl
    deadnix
    delta
    dig
    eza
    fd
    fzf
    go
    gotify-cli
    gotty
    harper
    htop
    iotop
    iproute2
    jq
    k3sup
    k9s
    kubectl
    kubectx
    kubernetes-helm
    mosh
    neovim
    nix-direnv
    nixfmt
    nodejs_22
    powertop
    pre-commit
    rclone
    ripgrep
    rustup
    sops
    statix
    strace
    tokei
    typescript
    uv
    wget
    yamllint
    yarn
    yq-go
    zoxide
    zsh
  ];
}
