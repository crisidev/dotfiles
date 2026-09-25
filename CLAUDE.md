# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal dotfiles managed as a Nix flake with standalone home-manager (non-NixOS hosts: Ubuntu desktop, Debian/other servers). Nothing here is a NixOS system config.

## Commands

```sh
./home-manager switch        # build + activate the config for $(hostname -s) (--impure, piped through nom if present)
./home-manager build         # build only; any home-manager subcommand/flags pass through
./home-manager pull          # nix flake update
nix fmt                      # format all .nix files (nixfmt)
statix check . && deadnix .  # lint (both are installed by the config)
nix build --impure .#homeConfigurations.falcon.activationPackage   # eval/build a specific host without activating
```

`./home-manager pull --all` also runs `home/programs/update-node-pkgs`, which bumps the pinned npm packages/hashes in `home/programs/node.nix`.

## Architecture

- `flake.nix` defines one `homeConfigurations.<host>` per machine; the `./home-manager` wrapper selects it by short hostname.
  - `falcon` — the GNOME desktop. Gets nixGL + `mash` overlays and `inputs` as `extraSpecialArgs`. Entry: `home/falcon.nix`.
  - `corellia`/`tatooine`/`mandalore`/`coruscant` share `home/corellia.nix`; `razor` (root) and `scarif` (debian) have their own. Servers use plain nixpkgs and must not depend on falcon-only inputs or on `config.theme`.
- `home/common.nix` is imported by every host (shell, git, starship, bat, yazi, scripts, direnv).
- `home/programs/*.nix` are per-program modules; host files choose which to import.
- `home/files/` holds raw config files and scripts referenced by the modules. Scripts in `home/files/bin` are only installed to `~/.bin` if listed in `home/programs/scripts.nix`.
- `system/` mirrors files for `/etc` and `/usr` (keyd, systemd units, udev, terminfo). These are **not** managed by home-manager; they are copied manually.
- GPU apps (kitty, ghostty, neovide) are wrapped via `home/nixGL.nix`, which uses the `nixGLPrefixIntel` option from `home/options.nix` (set in `falcon.nix`).

### Theming (falcon only)

`home/theme/palette.nix` is the single source of Tokyo Night Storm colours. `home/theme/default.nix` builds a recoloured Orchis GTK/Shell theme, Tela icons and wallpaper from it and exposes them as `config.theme` (`config.theme.palette.colors`, etc.). GNOME, Qt, flatpaks, Firefox, k9s, zathura and others read colours from there — never hardcode hex values or theme names in a program module.

### GNOME

`home/programs/gnome.nix` configures the host Ubuntu GNOME Shell (pop-shell tiling) entirely through `dconf.settings`: keybindings, workspaces, extension settings. No imperative `gsettings` scripts. Extensions are installed **by hand**; nix only enables/configures them, so a new extension's UUID must be added to `enabled-extensions` or the next switch disables it. A `staleDconf` activation step wipes unmanaged keys.

### Flatpaks

Flatpaks (Firefox, Ferdium, Signal, Spotify) cannot see `/nix/store` or host fontconfig, so `flatpak.nix` and `fonts.nix` use `home.activation` steps to copy themes, fonts, fontconfig and Firefox `user.js`/`userChrome.css` as real files (not symlinks). Firefox uses the legacy `~/.mozilla` profile root when it exists. Overrides live in `home/files/flatpak/overrides`.

## Conventions

- Comments in modules explain *why* (workarounds, upstream quirks); keep that style when editing.
- Commit subjects are short and imperative, bodies explain the reason.
