# Tokyo Night Storm — the one palette every themed module reads (GTK/Shell
# recolour, Qt, flatpak Firefox, GNOME extensions, starship, btop/k9s/zathura).
# Plain function (not a module) so host-agnostic modules like starship.nix can
# import it too. Names follow folke/tokyonight.nvim's storm palette.
{ lib }:
let
  hexByte = s: lib.fromHexString s;
  channels =
    c:
    let
      h = lib.removePrefix "#" c;
    in
    map (i: hexByte (builtins.substring i 2 h)) [
      0
      2
      4
    ];
in
rec {
  colors = {
    bgDarker = "#1b1e2d";
    bgDark = "#1f2335";
    bg = "#24283b";
    bgHighlight = "#292e42";
    bgVisual = "#2e3c64";
    terminalBlack = "#414868";
    fgGutter = "#3b4261";
    dark3 = "#545c7e";
    comment = "#565f89";
    dark5 = "#737aa2";
    fgDark = "#a9b1d6";
    fg = "#c0caf5";
    blue0 = "#3d59a1";
    blue = "#7aa2f7";
    cyan = "#7dcfff";
    blue1 = "#2ac3de";
    blue2 = "#0db9d7";
    magenta = "#bb9af7";
    purple = "#9d7cd8";
    orange = "#ff9e64";
    yellow = "#e0af68";
    green = "#9ece6a";
    green1 = "#73daca";
    green2 = "#41a6b5";
    teal = "#1abc9c";
    red = "#f7768e";
    red1 = "#db4b4b";
  };

  # "#7aa2f7" → "rgb(122,162,247)" (dconf keys of several extensions take this).
  rgb = c: "rgb(${lib.concatMapStringsSep "," toString (channels c)})";

  # "#7aa2f7" 0.3 → "rgba(122,162,247,0.3)"
  rgba = c: a: "rgba(${lib.concatMapStringsSep "," toString (channels c)},${toString a})";

  # "#7aa2f7" 0.3 → [ 0.478 0.635 0.969 0.3 ] (blur-my-shell's (dddd) colours).
  fractions = c: a: map (x: x / 255.0) (channels c) ++ [ a ];

  # "#7aa2f7" → "#ff7aa2f7" (Qt's #AARRGGBB, fully opaque).
  argb = c: "#ff${lib.removePrefix "#" c}";
}
