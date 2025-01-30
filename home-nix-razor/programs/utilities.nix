{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    antidote
    awscli2
    bat
    curl
    direnv
    eza
    fd
    feh
    figlet
    file
    fzf
    git
    htop
    hwinfo
    jq
    neovim
    nix-direnv
    nixfmt-rfc-style
    ripgrep
    starship
    strace
    which
    yazi
    yq
    zoxide
  ];
}
