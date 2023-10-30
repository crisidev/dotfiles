# 🤟 Crisidev Dotfiles - OSX version 🤟

Take what you need, it also comes warrant free 😊


* [Look and feel](#look-and-feel)
* [Configurations](#configurations)
    * [Window management](#window-management)
    * [Terminal](#terminal)
    * [Editor](#editor)
* [Installation](#installation)

## Look and feel

![Desktop](desktop.png)

## Configurations

My personal dotfiles are compatible with
[homesick](https://github.com/technicalpickles/homesick) /
[homeshick](https://github.com/andsens/homeshick)

### Window management

I make heavy use of tiled windows, based on the amazing [Yabai](https://github.com/koekeishiya/yabai) window manager.
Since I don't want to disable SIP and my setup is completely keyboard centric,
I use [Hammerspoon]() to configure keybinding and to overcome Yabai's
shortcomings when SIP is fully enabled. The fancy top bar is [SketchyBar](https://felixkratz.github.io/SketchyBar/)
and I use Yabai from [FelixKratz fork](https://github.com/FelixKratz/yabai/).

- Yabai [config](/home/.yabai/yabairc)
- Hammerspoon [config](home/.hammerspoon)
- SketchyBar [config](home/.config/sketchybar)

### Terminal

- [Zsh rc](/home/.zshrc) file
- Zsh [plugins](home/.zsh_plugins) for [antidote](https://getantidote.github.io/)
- [Zsh aliases](/home/.zsh_aliases) file
- [Zsh functions](/home/.zsh_functions) file
- [Starship](https://starship.rs) [config](/home/.config/starship.toml) file
- [Kitty](https://sw.kovidgoyal.net/kitty/) [config](/home/.config/kitty) file
- [Direnv](https://direnv.net/) [config](/home/.config/direnv) directory

### Editor

See my [lvim](https://github.com/crisidev/lvim) configuration.

## Installation

```sh
❯❯❯ git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
❯❯❯ git clone https://github.com/crisidev/dotfiles.git $HOME/.homesick/dotfiles
❯❯❯ source "$HOME/.homesick/repos/homeshick/homeshick.sh"
❯❯❯ homeshick link dotfiles
```
