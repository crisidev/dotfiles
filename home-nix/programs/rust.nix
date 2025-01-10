{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    inputs.bacon-ls.defaultPackage.${pkgs.system}
    cargo-audit
    cargo-bundle
    cargo-llvm-cov
    cargo-machete
    cargo-nextest
    cargo-outdated
    cargo-tarpaulin
    cargo-udeps
    cargo-update
    rustup
    sccache
    tokio-console
  ];
}
