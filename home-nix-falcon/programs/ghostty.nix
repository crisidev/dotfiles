{ pkgs, config, ... }:
let nixGL = import ../nixGL.nix { inherit pkgs config; };
in {
  programs.ghostty = {
    enable = true;
    package = nixGL pkgs.ghostty;
  };
}
