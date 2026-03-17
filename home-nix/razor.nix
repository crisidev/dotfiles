{ pkgs, ... }:
{
  imports = [
    ./common.nix
    ./programs/python-base.nix
  ];

  home = {
    username = "root";
    homeDirectory = "/root";
  };

  home.packages = with pkgs; [
    antidote
    awscli2
    bat
    curl
    deadnix
    delta
    eza
    fd
    fzf
    git
    jq
    neovim
    nixfmt
    ripgrep
    starship
    strace
    uv
    yazi
    yq-go
    zoxide
  ];
}
