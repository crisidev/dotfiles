{ ... }: {
  imports = [
    ./chromium.nix
    ./firefox.nix
    ./ghostty.nix
    ./python.nix
    ./neovide.nix
    ./node.nix
    ./rust.nix
    ./utilities.nix
    ./zathura.nix
  ];
}
