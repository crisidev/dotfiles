{ pkgs, ... }:
let extraNodePackages = import ./node-packages/default.nix { };
in {
  home.packages = with pkgs; [
    yarn
    nodejs_22
    typescript
    extraNodePackages.neovim
    extraNodePackages."@openai/codex"
    extraNodePackages."@anthropic-ai/claude-code"
    extraNodePackages."@owloops/claude-powerline"
  ];
}
