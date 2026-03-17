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
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tokio-console.url = "github:tokio-rs/console";
    mash.url = "github:crisidev/mash";
  };

  outputs =
    {
      home-manager,
      nixgl,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      # Servers: plain nixpkgs, no falcon-specific inputs leaked in
      mkServer =
        modules:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs modules;
        };

      # Falcon: nixGL + mash overlays, full inputs for hyprland flake packages
      falconPkgs = import nixpkgs {
        inherit system;
        overlays = [
          nixgl.overlay
          inputs.mash.overlays.default
        ];
      };

      corelliaModules = [ ./home-nix/corellia.nix ];
    in
    {
      # Available through `home-manager --flake .#host switch`
      homeConfigurations = {
        falcon = home-manager.lib.homeManagerConfiguration {
          pkgs = falconPkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home-nix/falcon.nix ];
        };
        corellia = mkServer corelliaModules;
        tatooine = mkServer corelliaModules;
        mandalore = mkServer corelliaModules;
        razor = mkServer [ ./home-nix/razor.nix ];
        scarif = mkServer [ ./home-nix/scarif.nix ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
