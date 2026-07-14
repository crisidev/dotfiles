{ pkgs, ... }:
{
  imports = [
    ./common.nix
    ./programs/python-base.nix
  ];

  home = {
    username = "debian";
    homeDirectory = "/home/debian";
  };

  home.packages = with pkgs; [
    antidote
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
    ripgrep
    rustup
    sops
    statix
    strace
    tmux
    tokei
    typescript
    uv
    wget
    yarn
    yq-go
    zoxide
  ];
}
