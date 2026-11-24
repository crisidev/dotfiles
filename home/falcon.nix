{ pkgs, ... }:
{
  imports = [
    ./profiles/workstation.nix
    ./programs/luks-tpm.nix
  ];

  home = {
    username = "bigo";
    homeDirectory = "/home/bigo/";
    # mash comes from the falcon-only flake input/overlay.
    packages = [ pkgs.mash ];
  };

  luksTpm = {
    enable = true;
    uuid = "4c792278-87eb-4a96-a63d-eee44b0439b8";
  };
}
