{ ... }:
let
  # Personal scripts kept from the old homesick ~/.bin. gsettings-update is gone:
  # its settings are declarative dconf in programs/gnome.nix now.
  scripts = [
    "ide" # kitty + nvim launcher (Super+Z; the `ide` in ghostty/kitty)
    "focus-switch" # workspace focus/back-and-forth + rebalance (GNOME keybinds)
    "monitor-switch" # per-monitor text scaling + kitty font size (autostarted)
    "clean-notifications" # dismiss all GNOME notifications (Super+Alt+M)
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
