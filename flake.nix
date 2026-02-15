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
    mash.url = "github:crisidev/mash";
  };

  outputs = { home-manager, nixgl, nixpkgs, ... }@inputs:
    let system = "x86_64-linux";
    in {
      # Available through `home-manager --flake .#user@host switch`
      homeConfigurations = {
        falcon = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              nixgl.overlay
              inputs.mash.overlays.default
            ];
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home-nix/falcon.nix ];
        };
        tatooine = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs rec { inherit system; };
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home-nix/corellia.nix ];
        };
        mandalore = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs rec { inherit system; };
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home-nix/corellia.nix ];
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
        scarif = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs rec { inherit system; };
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home-nix/scarif.nix ];
        };

      };
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
