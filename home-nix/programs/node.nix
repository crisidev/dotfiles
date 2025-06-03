{ pkgs, ... }:
let extraNodePackages = import ./node-packages/default.nix { };
in {
  home.packages = with pkgs; [
    yarn
    nodejs_22
    node2nix
    typescript
    extraNodePackages."@swsnr/gsebuild"
    extraNodePackages.neovim
  ];
}
