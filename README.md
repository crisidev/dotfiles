# 🤟 Crisidev Dotfiles 🤟

Take what you need, it also comes warrant free 😊

* [Version](#version)
* [Configurations](#configurations)
    * [Terminal](#terminal)
    * [Editor](#editor)
    * [X11](#x11)
    * [System](#system)
* [Gnome i3 startup](#gnome-i3-startup)
* [Installation](#installation)

## Version
The current version is 0.1

## Configurations
My personal dotfiles are compatible with [homesick](https://github.com/technicalpickles/homesick) / [homeshick](https://github.com/andsens/homeshick)

### Terminal
* [Zsh rc](/home/.zshrc) file
* [Zsh aliases](/home/.zsh_aliases) file
* [Zsh functions](/home/.zsh_functions) file
* [Zprezto](https://github.com/sorin-ionescu/prezto) [config](/home/.zpreztorc) file
* [Starship](https://starship.rs) [config](/home/.config/starship.toml) file
* [Kitty](https://sw.kovidgoyal.net/kitty/) [config](/home/.config/kitty) file
* [Tmux](https://github.com/tmux/tmux/wiki) [config](/home/.tmux.conf) file
* [Direnv](https://direnv.net/) [config](/home/.config/direnv) directory

### Editor
* I use [Neovim](https://neovim.io) 0.6 following HEAD
* [LunarVim](https://lunarvim.org):
    - [Lua config](/home/.config/lvim/config.lua)
    - [Lua plugins](/home/.config/lvim/lua/user/plugins.lua)
    - [Lua runtime](/home/.config/lvim/lua/user)
    - [Lua ftplugin](/home/.config/lvim/ftplugin)
* [Neovide](https://github.com/neovide/neovide)

### X11
* [i3](https://i3wm.org/) [config](/home/.config/i3/config) file
* [i3status-rs](https://github.com/greshake/i3status-rust) [top](/home/.config/i3/config/top.toml) and [bottom](/home/.config/i3/config/bottom.toml) bars
* [Autorandr](https://github.com/phillipberndt/autorandr) [config](/home/.config/autorandr) directory
* [Imwheel](https://manpages.ubuntu.com/manpages/artful/man1/imwheel.1.html) [config](/home/.imwheelrc) file
* [Picom](https://github.com/yshui/picom) [config](/home/.config/picom/picom.conf) file
* [Redshift](https://wiki.archlinux.org/title/redshift) [config](/home/.config/redshift/redshift.conf)
* [Dunst](https://dunst-project.org/) [config](/home/.config/i3/config/dunst/dunstrc) file
* [Ulauncher](https://ulauncher.io/) [config](/home/.config/ulauncher/settings.json) file

### System
* [Keyd](https://github.com/rvaiya/keyd) [config](/system/etc/keyd/keyd.cfg) file
* [Topgrade](https://github.com/r-darwish/topgrade) [config](/home/.config/topgrade.toml) file
* [Systemd i3wm startup](/home/.config/systemd/user)

There are also plenty of useless and useful scripts inside the [bin/folder](/home/.bin)

## Gnome i3 startup
I use [i3-gnome](https://github.com/i3-gnome/i3-gnome) to start i3 inside a Gnome session and [Gnome flashback](https://wiki.gnome.org/Projects/GnomeFlashback) to keep all the functionalities offered by Gnome but under i3.

My [i3 config](/home/.config/i3/config) ends with a call to systemctl which starts the userspace **wm.target**, starting all the software needed for my graphical session. The systemd units and configuration can be found [here](/home/.config/systemd/user).

If you want to start any of the service files in the directory above, just add this line to your i3 config

```config
exec "systemctl --user start wm.target"
```

and enable the units you want to start when **wm.target** has started:

```sh
❯❯❯ systemctl --user enable dunst.service picom.service gnome-polkit.service gnome-flashback.service ...
❯❯❯ systemctl --user start wm.target
```

## Installation
```sh
❯❯❯ git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
❯❯❯ git clone https://github.com/crisidev/dotfiles.git $HOME/.homesick/dotfiles
❯❯❯ source "$HOME/.homesick/repos/homeshick/homeshick.sh"
❯❯❯ homeshick link dotfiles
```
