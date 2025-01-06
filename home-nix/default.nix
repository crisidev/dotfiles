{
  inputs,
  config,
  pkgs,
  pkgs-stable,
  lib,
  ...
}:
let
  nixGL = import ./nixGL.nix { inherit pkgs config; };
in
{
  imports = [
    ./options.nix
    ./programs
  ];

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
