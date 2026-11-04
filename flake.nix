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

      # Falcon: nixGL + mash overlays, full inputs for flake packages
      falconPkgs = import nixpkgs {
        inherit system;
        overlays = [
          # nixGL still takes the `pcre` that nixpkgs removed, and its overlay
          # has no way to override it. It only runs pcregrep in a build-time
          # check, so hand it a pcre2 shim. Go back to `nixgl.overlay` once
          # https://github.com/nix-community/nixGL/pull/227 is merged.
          (final: _: {
            nixgl = final.callPackage "${nixgl}/nixGL.nix" {
              pcre = final.writeShellScriptBin "pcregrep" ''
                exec ${final.lib.getBin final.pcre2}/bin/pcre2grep "$@"
              '';
            };
          })
          inputs.mash.overlays.default
        ];
      };

      corelliaModules = [ ./home/corellia.nix ];
    in
    {
      # Available through `home-manager --flake .#host switch`
      homeConfigurations = {
        falcon = home-manager.lib.homeManagerConfiguration {
          pkgs = falconPkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home/falcon.nix ];
        };
        corellia = mkServer corelliaModules;
        tatooine = mkServer corelliaModules;
        mandalore = mkServer corelliaModules;
        coruscant = mkServer corelliaModules;
        razor = mkServer [ ./home/razor.nix ];
        scarif = mkServer [ ./home/scarif.nix ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
