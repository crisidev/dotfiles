{ lib, config, ... }:
{
  options = {
    identity = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Matteo Bigoi";
        description = "Name used for git authorship.";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "bigo@crisidev.org";
        description = "Email used for git authorship and signing.";
      };
      signingKey = lib.mkOption {
        type = lib.types.str;
        default = "099F4F3AA10B27C97B746F03AEFBBD3BE8C66E4A";
        description = "GPG key commits are signed with.";
      };
    };
    dotfiles.wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "${config.dotfiles.repoDir}/wallpapers/nix-d-nord-aurora.jpg";
      description = ''
        Source image for the recoloured desktop wallpaper. Read at activation
        (wallpapers are gitignored, so not flake-visible); skipped if missing.
      '';
    };
    dotfiles.repoDir = lib.mkOption {
      type = lib.types.str;
      default = "${lib.removeSuffix "/" config.home.homeDirectory}/.homesick/repos/dotfiles";
      description = ''
        Checkout of this repo. Out-of-store symlinks (claude settings) and the
        `home-manager` alias point here, so they must follow the clone when it
        lives elsewhere (e.g. imported by another flake).
      '';
    };
    nixGLPrefixIntel = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Will be prepended to commands which require working OpenGL.

        This needs to be set to the right nixGL package on non-NixOS systems.
      '';
    };
    nixGLPrefixNvidia = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Will be prepended to commands which require working OpenGL.

        This needs to be set to the right nixGL package on non-NixOS systems.
      '';
    };
  };
}
