{ ... }:
{
  imports = [
    ./options.nix
    ./programs
  ];

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
