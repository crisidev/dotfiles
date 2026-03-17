{ pkgs, ... }:
{
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
