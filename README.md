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
* [Zsh rc](/blob/main/home/.zshrc) file
* [Zsh aliases](/blob/main/home/.zsh_aliases) file
* [Zsh functions](/blob/main/home/.zsh_functions) file
* [Zprezto](https://github.com/sorin-ionescu/prezto) [config](/blob/main/home/.zpreztorc) file
* [Starship](https://starship.rs) [config](/blob/main/home/.config/starship.toml) file
* [Kitty](https://sw.kovidgoyal.net/kitty/) [config](/blob/main/home/.config/kitty) file
* [Tmux](https://github.com/tmux/tmux/wiki) [config](/blob/main/home/.tmux.conf) file
* [Direnv](https://direnv.net/) [config](/blob/main/home/.config/direnv) directory

### Editor
* I use [Neovim](https://neovim.io) 5 following the stable version
* [LunarVim](https://lunarvim.org):
    - [Lua config](/blob/main/home/.config/lvim/config.lua)
    - [Lua plugins](/blob/main/home/.config/lvim/lua/user/plugins.lua)
    - [Lua runtime](/blob/main/home/.config/lvim/lua/user)
    - [Lua ftplugin](/blob/main/home/.config/lvim/ftplugin)
* [Neovide](https://github.com/neovide/neovide)

### X11
* [i3](https://i3wm.org/) [config](/blob/main/home/.config/i3/config) file
* [i3status-rs](https://github.com/greshake/i3status-rust) [top](/blob/main/home/.config/i3/config/top.toml) and [bottom](/blob/main/home/.config/i3/config/bottom.toml) bars
* [Autorandr](https://github.com/phillipberndt/autorandr) [config](/blob/main/home/.config/autorandr) directory
* [Imwheel](https://manpages.ubuntu.com/manpages/artful/man1/imwheel.1.html) [config](/blob/main/home/.imwheelrc) file
* [Picom](https://github.com/yshui/picom) [config](/blob/main/home/.config/picom/picom.conf) file
* [Redshift](https://wiki.archlinux.org/title/redshift) [config](/blob/main/home/.config/redshift/redshift.conf)
* [Dunst](https://dunst-project.org/) [config](/blob/main/home/.config/i3/config/dunst/dunstrc) file
* [Ulauncher](https://ulauncher.io/) [config](/blob/main/home/.config/ulauncher/settings.json) file

### System
* [Keyd](https://github.com/rvaiya/keyd) [config](/blob/main/system/etc/keyd/keyd.cfg) file
* [Topgrade](https://github.com/r-darwish/topgrade) [config](/blob/main/home/.config/topgrade.toml) file
* [Systemd i3wm startup](/blob/main/home/.config/systemd/user)

There are also plenty of useless and useful scripts inside the [bin/folder](/blob/main/home/.bin)

## Gnome i3 startup
I use [i3-gnome](https://github.com/i3-gnome/i3-gnome) to start i3 inside a Gnome session and [Gnome flashback](https://wiki.gnome.org/Projects/GnomeFlashback) to keep all the functionalities offered by Gnome but under i3.

My [i3 config](/blob/main/home/.config/i3/config) ends with a call to systemctl which starts the userspace **wm.target**, starting all the software needed for my graphical session. The systemd units and configuration can be found [here](/blob/main/home/.config/systemd/user).

## Installation
```sh
❯❯❯ git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
❯❯❯ git clone https://github.com/crisidev/dotfiles.git $HOME/.homesick/dotfiles
❯❯❯ source "$HOME/.homesick/repos/homeshick/homeshick.sh"
❯❯❯ homeshick link dotfiles
```
