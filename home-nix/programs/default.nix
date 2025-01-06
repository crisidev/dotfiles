{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./chromium.nix
    ./firefox.nix
    ./gsettings.nix
    ./python.nix
    ./neovide.nix
    ./node.nix
    ./rust.nix
    ./utilities.nix
    ./zathura.nix
  ];
}
