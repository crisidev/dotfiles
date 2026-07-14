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
    jq
    neovim
    nixfmt
    ripgrep
    strace
    uv
    yazi
    yq-go
    zoxide
  ];
}
