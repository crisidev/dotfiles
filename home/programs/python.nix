{ pkgs, ... }:
{
  imports = [ ./python-base.nix ];

  home.packages = with pkgs; [
    neovim-remote
    poetry
    pre-commit
    pyxel
    uv
  ];
}
