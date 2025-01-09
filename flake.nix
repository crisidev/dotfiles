{
  description = "Bigo's Nix configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tokio-console = {
      url = "github:tokio-rs/console";
    };
    neovim = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
    };
  };

  outputs =
    { self
    , home-manager
    , neovim
    , nixgl
    , nixpkgs
    , nixpkgs-stable
    , treefmt-nix
    , tokio-console
    , ...
    }@inputs:
    {

      # Available through `home-manager --flake .#user@host switch`
      homeConfigurations = {
        falcon = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs rec {
            system = "x86_64-linux";
            overlays = [
              nixgl.overlay
              # neovim.overlays.default
            ];
          };
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./home.nix
          ];
        };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
