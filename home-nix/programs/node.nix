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
    version = "0.137.0";
    src = pkgs.fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v0.137.0/codex-x86_64-unknown-linux-musl.tar.gz";
      hash = "sha256-2W6IMTuVWX6cu4cE9tsW27gcBxQrCM+2KEeatDNpaTE=";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      tar xzf $src -C $out/bin
      mv $out/bin/codex-x86_64-unknown-linux-musl $out/bin/codex
    '';
  };

  claude-powerline = pkgs.buildNpmPackage {
    pname = "claude-powerline";
    version = "1.20.1";
    src = pkgs.fetchFromGitHub {
      owner = "Owloops";
      repo = "claude-powerline";
      rev = "v1.27.0";
      hash = "sha256-OdZ5nMNfiK3qEtW81ut2+e2SEfCzztFD34/pXadhBCE=";
    };
    npmDepsHash = "sha256-D3Z5tb4phZUMPQaXvfYiIWuwaX5YGI8ubgyV7sSJqQk=";
  };

  hunk = pkgs.stdenv.mkDerivation {
    pname = "hunk";
    version = "0.14.1";
    src = pkgs.fetchurl {
      url = "https://github.com/modem-dev/hunk/releases/download/v0.14.1/hunkdiff-linux-x64.tar.gz";
      hash = "sha256-enmhID6L4tr8+KDgvi8XvJhMsFC+GVoHEKh3YkSqiP4=";
    };
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = with pkgs; [ stdenv.cc.cc.lib ];
    sourceRoot = "hunkdiff-linux-x64";
    # Bun's `--compile` appends the JS payload after the ELF and locates it via a
    # trailing footer; default `strip` truncates the payload and the binary falls
    # back to plain bun. Skip every post-install rewrite that touches file bytes.
    dontStrip = true;
    dontPatchELF = true;
    installPhase = ''
      mkdir -p $out/bin
      install -Dm755 hunk $out/bin/hunk
    '';
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
    hunk
  ];
}
