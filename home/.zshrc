#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# Source Prezto.

#zmodload zsh/zprof
export skip_global_compinit=1

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# title
precmd () { print -Pn "\e]2;zsh | %~\a" } # title bar prompt

# completion
autoload -Uz compinit
compinit -i

# Customize to your needs...
# unsetopt CORRECT
setopt NO_LIST_BEEP

# 10 second wait if you do something that will delete everything.  I wish I'd had this before...
# setopt RM_STAR_WAIT

# use magic (this is default, but it can't hurt!)
setopt ZLE

# ?
setopt NO_HUP

# If I could disable Ctrl-s completely I would!
setopt NO_FLOW_CONTROL

# Keep echo "station" > station from clobbering station
# setopt CLOBBER

# Case insensitive globbing
setopt NO_CASE_GLOB

# Be Reasonable!
setopt NUMERIC_GLOB_SORT

# I don't know why I never set this before.
setopt EXTENDED_GLOB

# hows about arrays be awesome?  (that is, frew${cool}frew has frew surrounding all the variables, not just first and last
setopt RC_EXPAND_PARAM

# oh wow!  This is killer...  try it!
bindkey -M vicmd "q" push-line

# it's like, space AND completion.  Gnarlbot.
bindkey -M viins ' ' magic-space

# make ctrl-r work
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward
bindkey "^[f" forward-word
bindkey "^[b" backward-word

# bindkey -v
# bindkey -e

# history
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.
HISTFILE="$HOME/.zsh_history"

# source files
[ -f $HOME/.zsh_aliases ] && source $HOME/.zsh_aliases
[ -f $HOME/.zsh_amzn ] && source $HOME/.zsh_amzn
[ -f $HOME/.zsh_functions ] && source $HOME/.zsh_functions
[ -f $HOME/.zsh_secrets ] && source $HOME/.zsh_secrets

# paths
export PATH=$HOME/.bin:$HOME/.toolbox/bin:$HOME/.pyenv/bin:$HOME/.rbenv/bin:$HOME/.nodenv/bin:$HOME/.goenv/bin:$HOME/.bin:$HOME/.cargo/bin:$HOME/.android/Sdk/platform-tools:$HOME/.toolchain/aarch64-linux-musl/bin:$HOME/.nodenv/shims:$HOME/.pyenv/shims:$HOME/.rbenv/shims:$HOME/.goenv/shims:$PATH

# terminal
export TERMINFO=/usr/share/terminfo
# export TERM="xterm-kitty"
export TERMINAL=xterm-256color
export GREP_COLOR='1;31'
export VISUAL=vim
export EDITOR=vim
export PAGER=less
export P4CONFIG=.p4config
# export RUSTC_WRAPPER=~/.cargo/bin/sccache
export LANG="en_US.UTF-8"

# rbenv
export RBENV_ROOT="$HOME/.rbenv"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# direnv
if which direnv > /dev/null; then eval "$(direnv hook zsh)"; fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
if which pyenv > /dev/null; then 
  eval "$(pyenv init --path)"
  eval "$(pyenv virtualenv-init -)"
  source $HOME/.pyenv/completions/pyenv.zsh
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
fi

# nodenv
export NODENV_ROOT="$HOME/.nodenv"
if which nodenv > /dev/null; then 
  eval "$(nodenv init -)"
  export PATH=$PATH:~/.nodenv/versions/17.0.1/bin
fi

# godenv
export GOENV_ROOT="$HOME/.goenv"
if which goenv > /dev/null; then 
  export GOENV_GOPATH_PREFIX=$HOME/.go
  eval "$(goenv init -)" 
  export PATH=$PATH:$GOPATH/bin
fi

# sdkman
source "$HOME/.sdkman/bin/sdkman-init.sh"

# sshrc
compdef sshrc=ssh

# fzf
# [ -f ~/github/0updates/fzf-marks/fzf-marks.plugin.zsh ] && source ~/github/0updates/fzf-marks/fzf-marks.plugin.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude build'

# docktor
export DOCKTOR_API_URL=https://docktor.crisidev.org
export DRONE_SERVER=https://build.crisidev.org

# rip
export GRAVEYARD=~/.local/share/Trash

# android
export ANDROID_SDK_ROOT=~/.android/Sdk

# zoxide
eval "$(zoxide init zsh)"

# spaceship
eval "$(starship init zsh)"

# mcfly
export MCFLY_RESULTS=50  
export MCFLY_INTERFACE_VIEW=BOTTOM       
export MCFLY_RESULTS_SORT=LAST_RUN
eval "$(mcfly init zsh)"
