{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    age
    antidote
    awscli2
    bat
    brightnessctl
    clang_19
    cmake
    curl
    deadnix
    delta
    direnv
    eza
    fd
    feh
    figlet
    file
    font-awesome
    fzf
    gh
    git
    gitui
    glab
    glibc
    glow
    gcc-unwrapped
    go
    heaptrack
    htop
    hwinfo
    hyfetch
    hyperfine
    imagemagick
    jq
    just
    k9s
    kubectl
    kubectx
    kubernetes-helm
    kyverno
    lazygit
    ltrace
    lua
    luarocks
    mergiraf
    meson
    minikube
    mkdocs
    neofetch
    neovim
    nerd-fonts.symbols-only
    ninja
    nix-direnv
    nixfmt-rfc-style
    nix-output-monitor
    poppler
    ripgrep
    silicon
    sops
    (spotify-player.override {
      withAudioBackend = "pulseaudio";
      withStreaming = true;
      withDaemon = true;
      withMediaControl = true;
      withImage = true;
      withNotify = true;
      withSixel = true;
      withFuzzy = true;
    })
    starship
    statix
    strace
    tokei
    topgrade
    tzupdate
    valgrind
    wev
    which
    yazi
    ydotool
    yq
    zellij
    zenith
    zoxide
  ];
}
