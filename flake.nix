{
  description = "Bigo's Nix configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tokio-console.url = "github:tokio-rs/console";
    bacon-ls.url = "github:crisidev/bacon-ls";
    bacon.url = "github:Canop/bacon";
  };

  outputs = { bacon, bacon-ls, home-manager, nixgl, nixpkgs, ... }@inputs:
    let system = "x86_64-linux";
    in {
      # Available through `home-manager --flake .#user@host switch`
      homeConfigurations = {
        falcon = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs rec {
            inherit system;
            overlays = [
              nixgl.overlay
              # bacon.overlay.${system}
              # bacon-ls.overlay.${system}
            ];
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home-nix/falcon.nix ];
        };
        mandalore = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs rec { inherit system; };
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home-nix/mandalore.nix ];
        };
        corellia = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs rec { inherit system; };
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home-nix/corellia.nix ];
        };
        razor = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs rec { inherit system; };
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home-nix/razor.nix ];
        };
      };
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
