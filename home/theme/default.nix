# Desktop theme for falcon: Tokyo Night Storm on GTK/libadwaita, GNOME Shell,
# icons and wallpaper, all derived from ./palette.nix. Consumers read
# `config.theme.*` (gnome.nix, qt.nix, flatpak.nix, xdg-config.nix) instead of
# naming themes or hardcoding hex values themselves.
{
  pkgs,
  lib,
  config,
  ...
}:
let
  palette = import ./palette.nix { inherit lib; };
  c = palette.colors;
  home = lib.removeSuffix "/" config.home.homeDirectory;

  # ── GTK + Shell: Orchis, recoloured ─────────────────────────────────────────
  # Orchis' `nord` tweak swaps in src/_sass/_color-palette-nord.scss; replacing
  # that file re-skins every sass-built surface (GTK3/4 CSS, Shell CSS) while
  # keeping Orchis' layout, macos buttons and the rest. The few pre-rendered
  # assets that bake in Nord hex values are recoloured/re-rendered in postPatch.
  #
  # Dark variant mapping: accent = $blue-light, window = grey-800,
  # view = grey-700, view-alt = grey-750, cards/surfaces = grey-650.
  tokyonightScss = pkgs.writeText "_color-palette-tokyonight.scss" ''
    // Tokyo Night Storm, laid out as Orchis' nord palette (see home/theme).
    $red-light: ${c.red};
    $red-dark: ${c.red1};
    $pink-light: #f7a1c4;
    $pink-dark: #d6719b;
    $purple-light: ${c.magenta};
    $purple-dark: ${c.purple};
    $blue-light: ${c.blue};
    $blue-dark: ${c.blue0};
    $teal-light: ${c.green1};
    $teal-dark: ${c.teal};
    $green-light: ${c.green};
    $green-dark: #7fa854;
    $sea-light: ${c.green1};
    $sea-dark: ${c.green2};
    $yellow-light: ${c.yellow};
    $yellow-dark: #c49a55;
    $orange-light: ${c.orange};
    $orange-dark: #e08551;

    $grey-050: #f4f5fb;
    $grey-100: #e6e8f5;
    $grey-150: #d8dcf2;
    $grey-200: ${c.fg};
    $grey-250: #b4bce5;
    $grey-300: ${c.fgDark};
    $grey-350: #8f97c2;
    $grey-400: ${c.dark5};
    $grey-450: ${c.comment};
    $grey-500: ${c.dark3};
    $grey-550: ${c.terminalBlack};
    $grey-600: ${c.fgGutter};
    $grey-650: #2e3350;
    $grey-700: ${c.bg};
    $grey-750: #212538;
    $grey-800: ${c.bgDark};
    $grey-850: ${c.bgDarker};
    $grey-900: #16161e;
    $grey-950: #0c0d12;

    $white: #ffffff;
    $black: #000000;

    $button-close: ${c.red};
    $button-max: ${c.green};
    $button-min: ${c.yellow};
  '';

  gtkName = "Orchis-Dark-Tokyonight";

  orchisTokyonight = pkgs.orchis-theme.overrideAttrs (o: {
    pname = "orchis-tokyonight-theme";
    nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ [ pkgs.resvg ];

    postPatch = (o.postPatch or "") + ''
      cp ${tokyonightScss} src/_sass/_color-palette-nord.scss

      # Shell/cinnamon accent SVGs (checkbox, toggle, more-results).
      sed -i -e 's/#5e81ac/${c.blue0}/gI' -e 's/#89a3c2/${c.blue}/gI' \
        src/gnome-shell/theme-Nord/*.svg src/cinnamon/theme-Nord/*.svg

      # GTK3 PNG assets (sliders, selection checkboxes, selected rows): redo
      # upstream's make-assets.sh substitutions with our colours and re-render.
      pushd src/gtk
      sed -e 's/#1A73E8/${c.blue0}/g' -e 's/#3281EA/${c.blue}/g' \
          -e 's/#F2F2F2/#e6e8f5/g' -e 's/#2c2c2c/${c.bg}/g' \
          -e 's/#212121/${c.bgDark}/g' -e 's/#0f0f0f/#16161e/g' \
          -e 's/#ffffff/#f4f5fb/g' -e 's/#3C3C3C/#2e3350/g' \
          assets.svg > assets-Nord.svg
      for i in $(cat assets.txt); do
        resvg --export-id "$i" assets-Nord.svg "assets-Nord/$i.png"
        resvg --export-id "$i" --zoom 2 assets-Nord.svg "assets-Nord/$i@2.png"
      done
      rm assets-Nord.svg
      popd
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/themes
      bash install.sh -d $out/share/themes -t default -c dark -s standard \
        --tweaks nord macos
      # Orchis-Dark-Nord{,-hdpi,-xhdpi} → Orchis-Dark-Tokyonight…
      for d in $out/share/themes/Orchis-Dark-Nord*; do
        n="$out/share/themes/$(basename "$d" | sed 's/-Nord/-Tokyonight/')"
        mv "$d" "$n"
        [ -f "$n/index.theme" ] && sed -i 's/Orchis-Dark-Nord/${gtkName}/g' "$n/index.theme"
      done
      runHook postInstall
    '';
  });

  # ── Icons: Tela, one colour, Tokyo Night blue ───────────────────────────────
  # nixpkgs builds every Tela colour (`install.sh -a`); build only "blue", with
  # its folder hex swapped for the palette's. Yields Tela-tokyonight-blue{,-dark,-light}.
  telaTokyonight = pkgs.tela-icon-theme.overrideAttrs (o: {
    pname = "tela-tokyonight-icon-theme";
    postPatch = (o.postPatch or "") + ''
      substituteInPlace install.sh --replace-fail "'#5677fc'" "'${c.blue}'"
    '';
    installPhase = ''
      runHook preInstall
      patchShebangs install.sh
      mkdir -p $out/share/icons
      ./install.sh -n Tela-tokyonight -d $out/share/icons blue
      jdupes -l -r $out/share/icons
      runHook postInstall
    '';
  });

  # ── Wallpaper: an existing (gitignored, so not flake-visible) image
  # recoloured onto the palette with lutgen at activation. ──────────────────────
  wallpaperSrc = "${home}/.homesick/repos/dotfiles/wallpapers/nix-d-nord-aurora.jpg";
  wallpaperOut = "${home}/.local/share/backgrounds/tokyonight-storm-${baseNameOf wallpaperSrc}";
in
{
  options.theme = lib.mkOption {
    type = lib.types.raw;
    readOnly = true;
    description = "Desktop theme: palette, GTK/Shell/icon/cursor theme names and packages, wallpaper.";
  };

  config = {
    theme = {
      inherit palette;
      gtk = {
        name = gtkName;
        package = orchisTokyonight;
      };
      shell.name = "${gtkName}-Tall";
      icons = {
        name = "Tela-tokyonight-blue-dark";
        package = telaTokyonight;
      };
      cursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };
      wallpaper = "file://${wallpaperOut}";
    };

    home.activation.tokyonightWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      src=${lib.escapeShellArg wallpaperSrc}
      out=${lib.escapeShellArg wallpaperOut}
      if [ -f "$src" ] && { [ ! -f "$out" ] || [ "$src" -nt "$out" ]; }; then
        run mkdir -p "$(dirname "$out")"
        run ${pkgs.lutgen}/bin/lutgen apply -p tokyo-night-storm -o "$out" "$src"
      fi
    '';
  };
}
