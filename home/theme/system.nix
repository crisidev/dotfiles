# Boot and login in the desktop's palette: the Plymouth splash (and LUKS
# prompt), the GRUB menu and the GDM login screen. They live in /usr and /boot,
# out of home-manager's reach, so the themes are built into the store here and
# `system-theme install|revert [plymouth|grub|gdm]` copies them into place with
# sudo and runs the distro's update steps (update-alternatives, initramfs,
# update-grub). The wallpaper is gitignored (not flake-visible), so the GRUB and
# GDM backgrounds are rendered from it at install time.
{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config) theme;
  inherit (theme) island;
  inherit (theme.palette) rgba;
  c = theme.palette.colors;
  hex = lib.removePrefix "#";
  wallpaper = lib.removePrefix "file://" theme.wallpaper;

  name = "tokyonight";

  # ── Plymouth ────────────────────────────────────────────────────────────────
  # two-step (the module of Ubuntu's bgrt/spinner themes) on a flat bgDark
  # instead of the firmware logo: a blue arc spinner while booting, and the
  # LUKS password entry drawn as an island. Images are drawn at 4x and
  # downsampled for clean edges; plymouth scales them by the display's device
  # scale itself. Fonts stay Ubuntu: the initramfs hook only ships those.
  plymouthDir = "/usr/share/plymouth/themes/${name}";
  plymouthConf = ''
    [Plymouth Theme]
    Name=Tokyo Night
    Description=Tokyo Night Storm spinner and password island (dotfiles home/theme)
    ModuleName=two-step

    [two-step]
    Font=Ubuntu 12
    TitleFont=Ubuntu Light 30
    ImageDir=${plymouthDir}
    DialogHorizontalAlignment=.5
    DialogVerticalAlignment=.5
    TitleHorizontalAlignment=.5
    TitleVerticalAlignment=.382
    HorizontalAlignment=.5
    VerticalAlignment=.7
    Transition=none
    TransitionDuration=0.0
    BackgroundStartColor=0x${hex c.bgDark}
    BackgroundEndColor=0x${hex c.bgDark}
    ProgressBarBackgroundColor=0x${hex c.fgGutter}
    ProgressBarForegroundColor=0x${hex c.blue}
    DialogClearsFirmwareBackground=true
    MessageBelowAnimation=true

    [boot-up]
    UseEndAnimation=false
    UseFirmwareBackground=false

    [shutdown]
    UseEndAnimation=false
    UseFirmwareBackground=false

    [reboot]
    UseEndAnimation=false
    UseFirmwareBackground=false

    [updates]
    SuppressMessages=true
    ProgressBarShowPercentComplete=true
    UseProgressBar=true
    Title=Installing Updates...
    SubTitle=Do not turn off your computer

    [system-upgrade]
    SuppressMessages=true
    ProgressBarShowPercentComplete=true
    UseProgressBar=true
    Title=Upgrading System...
    SubTitle=Do not turn off your computer

    [firmware-upgrade]
    SuppressMessages=true
    ProgressBarShowPercentComplete=true
    UseProgressBar=true
    Title=Upgrading Firmware...
    SubTitle=Do not turn off your computer
  '';

  plymouthTheme =
    pkgs.runCommand "plymouth-theme-${name}"
      {
        nativeBuildInputs = [ pkgs.imagemagick ];
        inherit plymouthConf;
        passAsFile = [ "plymouthConf" ];
      }
      ''
        d=$out/share/plymouth/themes/${name}
        mkdir -p $d && cd $d
        cp $plymouthConfPath ${name}.plymouth
        stock=${pkgs.plymouth}/share/plymouth/themes/spinner

        # Spinner: a 100° blue arc over a faint ring, 10° a frame. Also the
        # end animation, which two-step wants present even when unused.
        for i in $(seq 0 35); do
          a=$((i * 10))
          f=$(printf 'throbber-%04d.png' $((i + 1)))
          magick -size 128x128 xc:none -fill none -strokewidth 10 \
            -stroke '${rgba c.blue 0.2}' -draw 'circle 64,64 64,14' \
            -stroke '${c.blue}' -draw "stroke-linecap round arc 14,14 114,114 $a,$((a + 100))" \
            -resize 32x32 "$f"
          cp "$f" "$(printf 'animation-%04d.png' $((i + 1)))"
        done

        # Password entry: an island the size of the stock one (305x34).
        magick -size 1220x136 xc:none -fill '${c.bg}' \
          -stroke '${island.border}' -strokewidth ${toString (4 * island.borderWidth)} \
          -draw 'roundrectangle 4,4 1215,131 ${toString (4 * island.radius)},${toString (4 * island.radius)}' \
          -resize 305x34 entry.png
        magick -size 40x40 xc:none -fill '${c.fg}' -draw 'circle 20,20 20,4' -resize 10x10 bullet.png

        # Stock glyphs (lock, caps lock, keyboard layout), recoloured.
        for f in lock capslock keyboard keymap-render; do
          magick $stock/$f.png -fill '${c.fg}' -colorize 100 $f.png
        done
      '';

  # ── GRUB ────────────────────────────────────────────────────────────────────
  # The menu as an island over the darkened wallpaper. Ubuntu hides the menu
  # (GRUB_TIMEOUT_STYLE=hidden, timeout 0), which would leave the theme unseen
  # outside recovery: the installed grub.d snippet shows it for grubTimeout
  # seconds instead (it is sourced after /etc/default/grub, so it wins).
  # Sizes are for the 2880x1800 panel at GRUB_GFXMODE=auto.
  grubTimeout = 2;
  grubDir = "/boot/grub/themes/${name}";
  grubFont = size: "Inter Variable Regular ${toString size}";
  grubConf = ''
    title-text: ""
    desktop-image: "background.png"
    desktop-image-scale-method: "crop"
    desktop-color: "${c.bgDark}"
    terminal-font: "${grubFont 32}"

    + boot_menu {
      left = 30%
      top = 30%
      width = 40%
      height = 40%
      menu_pixmap_style = "menu_*.png"
      item_font = "${grubFont 36}"
      item_color = "${c.fgDark}"
      selected_item_font = "${grubFont 36}"
      selected_item_color = "${c.fg}"
      selected_item_pixmap_style = "select_*.png"
      item_height = 72
      item_padding = 24
      item_spacing = 8
      icon_width = 0
      icon_height = 0
      scrollbar = false
    }

    + label {
      id = "__timeout__"
      left = 0
      top = 75%
      width = 100%
      align = "center"
      font = "${grubFont 28}"
      color = "${c.comment}"
      text = "Booting in %d seconds"
    }
  '';

  grubTheme =
    pkgs.runCommand "grub-theme-${name}"
      {
        nativeBuildInputs = [
          pkgs.grub2
          pkgs.imagemagick
        ];
        inherit grubConf;
        passAsFile = [ "grubConf" ];
      }
      ''
        d=$out/share/grub/themes/${name}
        mkdir -p $d && cd $d
        cp $grubConfPath theme.txt
        for s in 28 32 36; do
          grub-mkfont -s $s -o inter-$s.pf2 ${pkgs.inter}/share/fonts/truetype/InterVariable.ttf 2>/dev/null
        done

        # 9-slice pixmaps (GRUB stretches the edges and centre): a rounded
        # box drawn at 4x, downsampled, then cut into a 3x3 grid of r-sized
        # tiles.
        ninepatch() { # prefix fill stroke radius
          local r=$4 n=$(($4 * 3)) big=$(($4 * 12)) sw=$((4 * ${toString island.borderWidth}))
          magick -size ''${big}x''${big} xc:none -fill "$2" -stroke "$3" -strokewidth $sw \
            -draw "roundrectangle $((sw / 2)),$((sw / 2)) $((big - sw / 2 - 1)),$((big - sw / 2 - 1)) $((r * 4)),$((r * 4))" \
            -resize ''${n}x''${n} box.png
          local i=0
          for tile in nw n ne w c e sw s se; do
            magick box.png -crop "''${r}x''${r}+$(((i % 3) * r))+$(((i / 3) * r))" +repage "$1_$tile.png"
            i=$((i + 1))
          done
          rm box.png
        }
        ninepatch menu '${rgba c.bgDark 0.85}' '${island.border}' 24
        ninepatch select '${rgba c.blue 0.2}' 'none' 16
      '';

  # ── GDM ─────────────────────────────────────────────────────────────────────
  # GNOME 50's gdm session mode loads gdm.css from gdm-theme.gresource
  # (sessionMode.js), which Ubuntu points at a theme via update-alternatives.
  # This is the Orchis shell CSS (relative asset URLs resolve inside the
  # resource) plus the popups-as-islands CSS and the wallpaper, blurred like
  # blur-my-shell's lock screen. The installer adds the stock resource's other
  # files and compiles it.
  gdmCss = ''

    /* dotfiles home/theme/system.nix */
    #lockDialogGroup {
      background: ${c.bgDark} url("resource:///org/gnome/shell/theme/login-background.jpg");
      background-size: cover;
      background-position: center;
    }

    ${theme.shell.popupsCss}
  '';

  gdmTheme =
    pkgs.runCommand "gdm-theme-${name}"
      {
        inherit gdmCss;
        passAsFile = [ "gdmCss" ];
      }
      ''
        src=${theme.gtk.package}/share/themes/${theme.gtk.name}/gnome-shell
        d=$out/share/gnome-shell/theme/${name}
        mkdir -p $d
        cp -rL --no-preserve=mode $src/assets $src/pad-osd.css $d/
        cat $src/gnome-shell.css $gdmCssPath > $d/gdm.css
      '';

  gdmResource = "/usr/share/gnome-shell/theme/${name}/gnome-shell-theme.gresource";
  gdmStock = "/usr/share/gnome-shell/gnome-shell-theme.gresource";

  systemTheme = pkgs.writeShellApplication {
    name = "system-theme";
    runtimeInputs = with pkgs; [
      coreutils
      findutils
      glib
      imagemagick
    ];
    text = ''
      usage() {
        echo "usage: system-theme install|revert [plymouth|grub|gdm]..." >&2
        exit 1
      }
      [ $# -ge 1 ] || usage
      action=$1
      shift
      parts=("$@")
      [ ''${#parts[@]} -gt 0 ] || parts=(plymouth grub gdm)

      wallpaper=${lib.escapeShellArg wallpaper}
      stage=$(mktemp -d)
      trap 'rm -rf "$stage"' EXIT

      plymouth_install() {
        sudo rm -rf ${plymouthDir}
        sudo cp -rT --no-preserve=mode,ownership ${plymouthTheme}/share/plymouth/themes/${name} ${plymouthDir}
        sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth \
          ${plymouthDir}/${name}.plymouth 150
        sudo update-alternatives --set default.plymouth ${plymouthDir}/${name}.plymouth
        sudo update-initramfs -u
      }
      plymouth_revert() {
        sudo update-alternatives --remove default.plymouth ${plymouthDir}/${name}.plymouth || true
        sudo update-alternatives --auto default.plymouth
        sudo rm -rf ${plymouthDir}
        sudo update-initramfs -u
      }

      grub_install() {
        cp -r --no-preserve=mode ${grubTheme}/share/grub/themes/${name} "$stage/grub"
        magick "$wallpaper" -resize 1440x900^ -gravity center -extent 1440x900 \
          -fill '${c.bgDark}' -colorize 45% "$stage/grub/background.png"
        # /boot/grub/themes doesn't exist until a theme is installed.
        sudo mkdir -p ${dirOf grubDir}
        sudo rm -rf ${grubDir}
        sudo cp -rT --no-preserve=mode,ownership "$stage/grub" ${grubDir}
        printf '%s\n' \
          '# dotfiles: system-theme (home/theme/system.nix)' \
          'GRUB_THEME="${grubDir}/theme.txt"' \
          'GRUB_GFXMODE=auto' \
          'GRUB_TIMEOUT_STYLE=menu' \
          'GRUB_TIMEOUT=${toString grubTimeout}' |
          sudo tee /etc/default/grub.d/99-${name}.cfg >/dev/null
        sudo update-grub
      }
      grub_revert() {
        sudo rm -rf ${grubDir} /etc/default/grub.d/99-${name}.cfg
        sudo update-grub
      }

      gdm_install() {
        # Start from the stock resource so every file gdm expects is there,
        # then lay the theme over it.
        res="$stage/gdm"
        mkdir -p "$res"
        gresource list ${gdmStock} | while read -r f; do
          mkdir -p "$res/$(dirname "''${f#/org/gnome/shell/theme/}")"
          gresource extract ${gdmStock} "$f" > "$res/''${f#/org/gnome/shell/theme/}"
        done
        cp -r --no-preserve=mode ${gdmTheme}/share/gnome-shell/theme/${name}/. "$res/"
        magick "$wallpaper" -resize 1920x1200^ -gravity center -extent 1920x1200 \
          -blur 0x24 -fill '${c.bgDark}' -colorize 40% -quality 90 "$res/login-background.jpg"
        {
          echo '<?xml version="1.0" encoding="UTF-8"?>'
          echo '<gresources><gresource prefix="/org/gnome/shell/theme">'
          (cd "$res" && find . -type f | sed 's|^\./||' | sort | sed 's|.*|<file>&</file>|')
          echo '</gresource></gresources>'
        } > "$stage/gdm.gresource.xml"
        glib-compile-resources --sourcedir "$res" --target "$stage/gdm.gresource" "$stage/gdm.gresource.xml"
        sudo install -Dm644 "$stage/gdm.gresource" ${gdmResource}
        sudo update-alternatives --install /usr/share/gnome-shell/gdm-theme.gresource gdm-theme.gresource \
          ${gdmResource} 15
        sudo update-alternatives --set gdm-theme.gresource ${gdmResource}
        echo "gdm: takes effect at the next login screen"
      }
      gdm_revert() {
        sudo update-alternatives --set gdm-theme.gresource ${gdmStock}
        sudo update-alternatives --remove gdm-theme.gresource ${gdmResource} || true
        sudo rm -rf "$(dirname ${gdmResource})"
      }

      case $action in
        install | revert) ;;
        *) usage ;;
      esac
      for part in "''${parts[@]}"; do
        case $part in
          plymouth | grub | gdm) "''${part}_$action" ;;
          *) usage ;;
        esac
      done
    '';
  };
in
{
  home.packages = [ systemTheme ];
}
