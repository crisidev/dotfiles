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
    # Maintainer's fork of Wayle with a full notification-portal backend
    # (follow-up to PR #333). Deliberately pinned to its OWN nixpkgs — NO
    # `follows = "nixpkgs"` — because its flake.nix carries a committed cargoHash
    # over the vendored `wayle-services` git dependencies; re-vendoring under a
    # different nixpkgs' fetchCargoVendor could invalidate that hash. Testing
    # only: revert by dropping this input and restoring the pkgs.wayle patch in
    # home/programs/wayle.nix. See https://github.com/waltmck/wayle.
    wayle.url = "github:waltmck/wayle";
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
