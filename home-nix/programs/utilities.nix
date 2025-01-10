{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    age
    awscli2
    bat
    brightnessctl
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
    gitui
    glab
    glow
    go
    heaptrack
    htop
    hwinfo
    hyfetch
    hyperfine
    imagemagick
    jq
    just
    k9s
    kubectl
    kubectx
    kubernetes-helm
    kyverno
    lazygit
    ltrace
    lua
    luarocks
    mergiraf
    meson
    minikube
    mkdocs
    neofetch
    neovim
    nerd-fonts.symbols-only
    ninja
    nix-direnv
    nixfmt-rfc-style
    nix-output-monitor
    poppler
    ripgrep
    silicon
    sops
    starship
    statix
    strace
    terraform
    terraform-plugin-docs
    tokei
    topgrade
    # treefmt-nix
    valgrind
    wev
    which
    yazi
    ydotool
    yq
    zellij
    zenith
    zoxide
  ];
}
