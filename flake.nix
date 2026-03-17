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
      hyprland,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      mkHome =
        modules: overlays:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system overlays; };
          extraSpecialArgs = { inherit inputs; };
          inherit modules;
        };

      corelliaConfig = mkHome [ ./home-nix/corellia.nix ] [ ];
    in
    {
      # Available through `home-manager --flake .#user@host switch`
      homeConfigurations = {
        falcon =
          mkHome
            [ ./home-nix/falcon.nix ]
            [
              nixgl.overlay
              inputs.mash.overlays.default
            ];
        corellia = corelliaConfig;
        tatooine = corelliaConfig;
        mandalore = corelliaConfig;
        razor = mkHome [ ./home-nix/razor.nix ] [ ];
        scarif = mkHome [ ./home-nix/scarif.nix ] [ ];
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
