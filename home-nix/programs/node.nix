{ pkgs, ... }:
let
  extraNodePackages = import ./node-packages/default.nix { };
in
{
  home.packages = with pkgs; [
    happy-coder
    yarn
    nodejs_22
    typescript
    extraNodePackages.neovim
    extraNodePackages."@openai/codex"
    extraNodePackages."@owloops/claude-powerline"
  ];
}
