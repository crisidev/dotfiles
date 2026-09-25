{ pkgs, ... }:
let
  neovim-node-client = pkgs.buildNpmPackage {
    pname = "neovim";
    version = "5.5.0";
    src = pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "node-client";
      rev = "v5.5.0";
      hash = "sha256-bhO52di2NmXk2VI8eFwxVKkPh1yEGJCeWXp3xLBWFFQ=";
    };
    npmDepsHash = "sha256-Vl6VPcwDrYAC4HWeY+6eWPl/2+Mw6fkScS5fsrLlWxw=";
    npmWorkspace = "packages/neovim";
    # Monorepo creates symlinks to sibling workspaces that aren't installed
    preFixup = ''
      find $out -xtype l -delete
    '';
  };

  claude-powerline = pkgs.buildNpmPackage {
    pname = "claude-powerline";
    version = "1.32.0";
    src = pkgs.fetchFromGitHub {
      owner = "Owloops";
      repo = "claude-powerline";
      rev = "v1.32.0";
      hash = "sha256-RyhIDeVWgp58lU2D18vvzHm/tkTMreijur2mBjS6lVw=";
    };
    npmDepsHash = "sha256-D3Z5tb4phZUMPQaXvfYiIWuwaX5YGI8ubgyV7sSJqQk=";
  };

  moremaid = pkgs.buildNpmPackage {
    pname = "moremaid";
    version = "1.16.1";
    src = pkgs.fetchFromGitHub {
      owner = "thieso2";
      repo = "moremaid";
      rev = "v1.16.1";
      hash = "sha256-q5TDC/IUvgHRPzkY0JxLdy5u6OWH2fDRRZ06WT/EiQA=";
    };
    npmDepsHash = "sha256-206AnyikamnPojzFarFxLO/BfjGZyFlYgM3+melxzBY=";
    # Puppeteer's postinstall downloads Chrome, which fails in the sandbox
    env.PUPPETEER_SKIP_DOWNLOAD = "1";
    # Plain JS package, no build script
    dontNpmBuild = true;
  };

  # Packaged from the npm tarball rather than source: it ships a prebuilt
  # Next.js standalone server (with its own node_modules), which avoids running
  # `next build` and fetching sharp's native binaries in the sandbox.
  cc-lens = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "cc-lens";
    version = "0.4.1";
    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/cc-lens/-/cc-lens-${version}.tgz";
      hash = "sha256-SbKiaEUM3PkzdfQ0pn8A/dwdGHo1NK3Tt78a93iR3wU=";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      mkdir -p $out/lib/node_modules/cc-lens
      cp -r . $out/lib/node_modules/cc-lens
      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/cc-lens \
        --add-flags $out/lib/node_modules/cc-lens/bin/cli.js
    '';
  };

in
{
  home.packages = with pkgs; [
    cc-lens
    gemini-cli
    yarn
    nodejs_22
    typescript
    neovim-node-client
    claude-powerline
    moremaid
  ];
}
