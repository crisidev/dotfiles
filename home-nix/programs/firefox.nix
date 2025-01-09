{
  config,
  pkgs,
  ...
}:
let
  # nixGL = import ../nixGLNvidia.nix {inherit pkgs config;};
  nixGL = import ../nixGL.nix { inherit pkgs config; };
in
{
  programs.firefox = {
    enable = false;
    package = nixGL pkgs.firefox;
  };
}
