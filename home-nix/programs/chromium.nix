{ pkgs
, config
, ...
}:
let
  nixGL = import ../nixGLNvidia.nix { inherit pkgs config; };
in
{
  programs.chromium = {
    enable = false;
    package = nixGL pkgs.chromium;
  };
}
