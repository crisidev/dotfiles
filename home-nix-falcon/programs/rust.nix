{ pkgs, ... }: {
  home.packages = with pkgs; [
    bacon
    bacon-ls
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
