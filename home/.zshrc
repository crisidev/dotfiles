# zmodload zsh/zprof

# rtx and cargo are the first things to load
[ -f $HOME/.cargo/env ] && source $HOME/.cargo/env
if which rtx > /dev/null; then
    eval "$(rtx activate zsh)"
fi

# paths
MY_PATH="$HOME/.bin:$HOME/.local/share/lvim/mason/bin:/opt/homebrew/bin"
BREW_PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/opt/grep/libexec/gnubin:/opt/homebrew/opt/ssh-copy-id/bin:/opt/homebrew/opt/gnu-tar/libexec/gnubin:/opt/homebrew/opt/llvm/bin"
SYSTEM_PATH="/usr/local/bin"
export PATH="$MY_PATH:$BREW_PATH:$SYSTEM_PATH:$PATH"

# configure fzf history search
export ZSH_FZF_HISTORY_SEARCH_BIND="^f"
export ZSH_FZF_HISTORY_SEARCH_FZF_ARGS="+s +m +x -e --height 40% --reverse"

# configure antidote
autoload -Uz compinit
compinit
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote load $HOME/.zsh_plugins

# options
setopt NO_LIST_BEEP
setopt NO_CASE_GLOB # Case insensitive globbing
setopt NUMERIC_GLOB_SORT # Be Reasonable!
setopt EXTENDED_GLOB # I don't know why I never set this before.
setopt RC_EXPAND_PARAM # hows about arrays be awesome?  (that is, frew${cool}frew has frew surrounding all the variables, not just first and last

# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
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
unsetopt HIST_BEEP               # Beep when accessing nonexistent history.

# history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# source files
[ -f $HOME/.zsh_aliases ] && source $HOME/.zsh_aliases
[ -f $HOME/.zsh_private ] && source $HOME/.zsh_private
[ -f $HOME/.zsh_functions ] && source $HOME/.zsh_functions
[ -f $HOME/.zsh_secrets ] && source $HOME/.zsh_secrets

# # terminal
export GREP_COLOR='mt=1;31'
export EDITOR="$(which lvim)"
export VISUAL="$(which lvim)"
export MANPAGER="$(which lvim) +Man!"
export XDG_CONFIG_HOME="$HOME/.config"

# lesspipe
export LESSOPEN="|/opt/homebrew/bin/lesspipe.sh %s"

# Rustc
# export RUSTC_WRAPPER=$HOME/.cargo/bin/sccache

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude build'

# brew
_evalcache /opt/homebrew/bin/brew shellenv
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

# direnv
if which direnv > /dev/null; then
    _evalcache direnv hook zsh
fi

# zoxide
if which zoxide > /dev/null; then
    _evalcache zoxide init zsh
fi

# spaceship
if which starship > /dev/null; then
    _evalcache starship init zsh
fi

# aws cli completer
complete -C "$(rtx which aws)_completer" aws

# complete jira
if which jira > /dev/null; then
    _evalcache jira completion zsh
fi

zstyle ':completion:*:(ssh|scp|rsync):*' ignored-patterns '*(.|:)*'
zstyle ':completion:*:(ssh|scp|rsync):*' hosts
zstyle ':completion:*:(ssh|scp|rsync):*' users

# export cross toolchains
# needed to compile for x86 linux
export CC_x86_64_unknown_linux_gnu=x86_64-unknown-linux-gnu-gcc
export CXX_x86_64_unknown_linux_gnu=x86_64-unknown-linux-gnu-g++
export AR_x86_64_unknown_linux_gnu=x86_64-unknown-linux-gnu-ar
export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=x86_64-unknown-linux-gnu-gcc
export CC_x86_64_unknown_linux_musl=x86_64-unknown-linux-musl-gcc
export CXX_x86_64_unknown_linux_musl=x86_64-unknown-linux-musl-g++
export AR_x86_64_unknown_linux_musl=x86_64-unknown-linux-musl-ar
export CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER=x86_64-unknown-linux-musl-gcc

# needed to compile for arm64 linux
export CC_AARCH64_unknown_linux_gnu=aarch64-unknown-linux-gnu-gcc
export CXX_AARCH64_unknown_linux_gnu=aarch64-unknown-linux-gnu-g++
export AR_AARCH64_unknown_linux_gnu=aarch64-unknown-linux-gnu-ar
export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-unknown-linux-gnu-gcc
export CC_AARCH64_unknown_linux_musl=aarch64-unknown-linux-musl-gcc
export CXX_AARCH64_unknown_linux_musl=aarch64-unknown-linux-musl-g++
export AR_AARCH64_unknown_linux_musl=aarch64-unknown-linux-musl-ar
export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_LINKER=aarch64-unknown-linux-musl-gcc

# zprof
