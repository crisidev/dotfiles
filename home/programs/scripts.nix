{ ... }:
let
  # Personal scripts kept from the old homesick ~/.bin. The GNOME/pop-shell-era
  # ones (clean-notifications, focus-switch, monitor-switch, gsettings-update,
  # tokynight-grey-fix) were dropped — they drove org.gnome.Shell extensions that
  # don't exist under Hyprland.
  scripts = [
    "ide" # kitty + nvim launcher (Super+Z; the `ide` in ghostty/kitty)
    "hypr-float-window" # pick a window → persistent float rule in hyprland.nix
    "siliconic" # silicon code screenshots (bat TokyoNight theme)
    "idle-suppressor" # nudge the mouse to defeat idle
    "startup" # boot-time net/disk tuning (guarded per-host)
    "unlock" # remote LUKS unlock of the servers over SSH
    "update-clevis" # rebind this host's LUKS to TPM2
    "grcov-report" # rust coverage report
    "gh-repo-cleanup" # github repo housekeeping
    "stylepak" # apply the host GTK theme to flatpaks
  ];
in
{
  home.file = builtins.listToAttrs (
    map (name: {
      name = ".bin/${name}";
      value = {
        source = ../files/bin/${name};
        executable = true;
      };
    }) scripts
  );
}
