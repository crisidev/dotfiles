{ ... }: {
  imports = [
    ./python.nix
    ./neovide.nix
    ./node.nix
    ./rust.nix
    ./utilities.nix
    ./zathura.nix
  ];
}
