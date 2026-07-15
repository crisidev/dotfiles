{ pkgs, ... }:
{
  # Cargo config — ported 1:1 from home/.cargo/config.toml (there is no
  # home-manager cargo module, so render the TOML directly). Cross-compile
  # linkers for the arm targets (host cross-gcc toolchains), plus
  # tokio_unstable so tokio-console task instrumentation works.
  # The old file also had a commented-out x86_64 experiment; to try it again:
  #   target."x86_64-unknown-linux-gnu" = {
  #     linker = "clang";
  #     rustflags = [ "-C" "link-arg=--ld-path=wild" ];
  #   };
  home.file.".cargo/config.toml".source = (pkgs.formats.toml { }).generate "cargo-config.toml" {
    target = {
      "aarch64-unknown-linux-gnu".linker = "aarch64-linux-gnu-gcc";
      "aarch64-unknown-linux-musl".linker = "aarch64-linux-gnu-gcc";
      "armv7-unknown-linux-gnueabihf".linker = "arm-linux-gnueabihf-gcc";
      "armv7-unknown-linux-gnueabi".linker = "arm-linux-gnueabi-gcc";
    };
    build.rustflags = [
      "--cfg"
      "tokio_unstable"
    ];
  };

  home.packages = with pkgs; [
    cargo-audit
    cargo-bundle
    cargo-llvm-cov
    cargo-machete
    cargo-nextest
    cargo-outdated
    cargo-tarpaulin
    cargo-udeps
    cargo-update
    grcov
    llvmPackages_19.libllvm
    rustup
    sccache
    tokio-console
  ];
}
