{ pkgs, ... }: {
  home.packages = with pkgs; [ yarn nodejs_22 node2nix typescript ];
}
