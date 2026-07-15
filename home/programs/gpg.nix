{ pkgs, ... }:
{
  # GnuPG — ported from home/.gnupg/{gpg.conf,gpg-agent.conf}. The old gpg.conf was
  # 99% the stock template; programs.gpg already applies hardened defaults
  # (require-cross-certification, SHA512 digests, no-comments, …), so only the one
  # meaningful non-default is set here. keys.gnupg.net died with the SKS network
  # (~2021), so it's replaced with keys.openpgp.org. Obsolete no-ops from the old
  # file (use-agent, use-standard-socket) are dropped. Keyrings stay user-managed
  # (mutableKeys defaults true).
  programs.gpg = {
    enable = true;
    settings.keyserver = "hkps://keys.openpgp.org";
  };

  # gpg-agent — ttls ported 1:1 from the old gpg-agent.conf. pinentry moves from
  # the system /usr/bin/pinentry to nix's GNOME pinentry. NOTE: on Hyprland a GUI
  # pinentry needs a running prompter; if the passphrase dialog never appears when
  # signing, swap pinentry-gnome3 → pinentry-qt (standalone) or pinentry-curses.
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 28800;
    maxCacheTtl = 86400;
    pinentry.package = pkgs.pinentry-gnome3;
  };
}
