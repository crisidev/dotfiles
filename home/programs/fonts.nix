{ pkgs, lib, ... }:
let
  # macOS-like UI typography with open lookalikes (Apple's SF fonts aren't
  # redistributable): Inter ≈ SF Pro, Source Serif 4 ≈ New York,
  # JetBrains Mono ≈ SF Mono. kitty is unaffected — it names MonoLisa itself.
  uiFonts = with pkgs; [
    inter
    source-serif
    jetbrains-mono
  ];

  sans = "Inter";
  serif = "Source Serif 4";
  mono = "JetBrains Mono";

  alias = from: to: ''
    <alias binding="same">
      <family>${from}</family>
      <prefer><family>${to}</family></prefer>
    </alias>
  '';

  # One fontconfig file for host AND flatpaks (which can't read the host's
  # ~/.config/fontconfig, nor anything under /nix/store).
  fontsConf = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <!-- macOS-like rendering: grayscale antialiasing, slight hinting (keeps
           glyph shapes instead of snapping them to the pixel grid), no
           subpixel colour fringes. -->
      <match target="font">
        <edit name="antialias" mode="assign"><bool>true</bool></edit>
        <edit name="hinting" mode="assign"><bool>true</bool></edit>
        <edit name="hintstyle" mode="assign"><const>hintslight</const></edit>
        <edit name="rgba" mode="assign"><const>none</const></edit>
        <edit name="lcdfilter" mode="assign"><const>lcdnone</const></edit>
      </match>

      <!-- Generic families. -->
      ${alias "sans-serif" sans}
      ${alias "system-ui" sans}
      ${alias "serif" serif}
      ${alias "monospace" mono}
      ${alias "emoji" "Noto Color Emoji"}

      <!-- Apple family names that web pages / apps ask for. -->
      ${lib.concatMapStrings (f: alias f sans) [
        "-apple-system"
        "BlinkMacSystemFont"
        "SF Pro"
        "SF Pro Text"
        "SF Pro Display"
        "Helvetica"
        "Helvetica Neue"
        "Arial"
      ]}
      ${alias "New York" serif}
      ${lib.concatMapStrings (f: alias f mono) [
        "SF Mono"
        "Menlo"
        "Monaco"
      ]}
    </fontconfig>
  '';

  fontsConfFile = pkgs.writeText "mac-fonts.conf" fontsConf;
in
{
  home.packages = uiFonts;

  # Host: conf.d/50-hm-mac-fonts.conf (loaded via 50-user.conf, i.e. before the
  # distro's 60-latin.conf, so these preferences win).
  fonts.fontconfig.configFile.mac-fonts = {
    # Entries default to disabled below stateVersion 26.11.
    enable = true;
    text = fontsConf;
    priority = 50;
  };

  # Flatpaks see only real files: ~/.local/share/fonts (remapped to
  # /run/host/user-fonts) and their own $XDG_CONFIG_HOME
  # (~/.var/app/<id>/config). So copy the UI fonts there as real files, and
  # drop the same fontconfig file into every installed app's config.
  home.activation.flatpakFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    dst="$HOME/.local/share/fonts/hm-ui"
    run rm -rf "$dst"
    run mkdir -p "$dst"
    ${lib.concatMapStrings (p: ''
      run cp -rL --no-preserve=mode ${p}/share/fonts/. "$dst/"
    '') uiFonts}
    for app in "$HOME"/.var/app/*/; do
      run install -D -m644 ${fontsConfFile} "$app/config/fontconfig/conf.d/50-hm-mac-fonts.conf"
    done
  '';
}
