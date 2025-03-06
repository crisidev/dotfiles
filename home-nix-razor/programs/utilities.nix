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
    (python312.withPackages (p:
      with p; [
        black
        boto3
        boto3-stubs
        ipython
        isort
        pip
        pynvim
        pytest
        virtualenv
        numpy
      ]))
    ripgrep
    starship
    strace
    uv
    which
    yazi
    yq
    zoxide
  ];
}
