{ pkgs, lib, ... }:
let
  neovim-node-client = pkgs.buildNpmPackage {
    pname = "neovim";
    version = "5.4.0";
    src = pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "node-client";
      rev = "v5.4.0";
      hash = "sha256-nAV0X5882Ps5zDPfmoRHm0a0NtzCOpBQEZqOT2/GCZU=";
    };
    npmDepsHash = "sha256-AN3TVvCyWjjm1GfnI+ZMt27KQC7qYxQ0bcysAaDsyz4=";
    npmWorkspace = "packages/neovim";
    # Monorepo creates symlinks to sibling workspaces that aren't installed
    preFixup = ''
      find $out -xtype l -delete
    '';
  };

  openai-codex = pkgs.stdenv.mkDerivation {
    pname = "openai-codex";
    version = "0.116.0";
    src = pkgs.fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v0.116.0/codex-x86_64-unknown-linux-gnu.tar.gz";
      hash = "sha256-nHzLauLazZK2ziXVUllO3JuwaD9/GDaoJZluKeje2VQ=";
    };
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = with pkgs; [ libcap openssl zlib stdenv.cc.cc.lib ];
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      tar xzf $src -C $out/bin
      mv $out/bin/codex-x86_64-unknown-linux-gnu $out/bin/codex
    '';
  };

  claude-powerline = pkgs.buildNpmPackage {
    pname = "claude-powerline";
    version = "1.20.1";
    src = pkgs.fetchFromGitHub {
      owner = "Owloops";
      repo = "claude-powerline";
      rev = "v1.20.1";
      hash = "sha256-qTVQSusLov+BtMv7V0/ZCUJvfbMRftxZ2q4WXtc3yGI=";
    };
    npmDepsHash = "sha256-qyExxspRcLcijtzZElCi889tM7rdPm2KiwWBO65f8ug=";
  };
in
{
  home.packages = with pkgs; [
    yarn
    nodejs_22
    typescript
    neovim-node-client
    openai-codex
    claude-powerline
  ];
}
