# zmodload zsh/zprof

# paths
export PATH="$HOME/.bin:$PATH:$HOME/.local/share/nvim/mason/bin:$HOME/.local/bin:$HOME/.go/bin:$HOME/.cargo/bin:/usr/local/bin:/usr/sbin"

# configure fzf history search
export ZSH_FZF_HISTORY_SEARCH_BIND="^f"
export ZSH_FZF_HISTORY_SEARCH_FZF_ARGS="+s +m +x -e --height 40% --reverse"
export DISABLE_AUTO_TITLE=true

# configure antidote and compinit
FPATH="$HOME/.zfunc:${FPATH}"
autoload -Uz compinit
compinit
source /usr/share/zsh-antidote/antidote.zsh
antidote load $HOME/.zsh_plugins

# ollama
#export ZSH_COPILOT_KEY='^h'  # Key to trigger suggestions (default: Ctrl+Z)
#export ZSH_COPILOT_OLLAMA_MODEL='llama3.1:8b'  # Ollama model to use
#export ZSH_COPILOT_SEND_CONTEXT=true  # Send shell context to the model
#export ZSH_COPILOT_DEBUG=false  # Enable debug mode
#source ~/.zsh-copilot/zsh-copilot.plugin.zsh

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
[ -f $HOME/.zsh_functions ] && source $HOME/.zsh_functions
[ -f $HOME/.zsh_secrets ] && source $HOME/.zsh_secrets

# # terminal
export GREP_COLOR='mt=1;31'
export EDITOR="$(which nvim)"
export VISUAL="$(which nvim)"
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
export ENABLE_WAKATIME=false

# Lazyvim
export LAZYVIM_RUST_DIAGNOSTICS=bacon-ls
export LAZYVIM_AI=none
export LAZYVIM_THEME=tokyonight

# Go
export GOPATH="$HOME/.go"

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude build'
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none
  --color=bg+:#2e3c64 \
  --color=border:#29a4bd \
  --color=fg:#c0caf5 \
  --color=gutter:#1f2335 \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#29a4bd \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"

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

# batpipe
if which batpipe > /dev/null; then
    _evalcache batpipe
fi

# aws cli completer
complete -C "aws_completer" aws

# ssh complete
zstyle ':completion:*:(ssh|scp|rsync):*' ignored-patterns '*(.|:)*'
zstyle ':completion:*:(ssh|scp|rsync):*' hosts
zstyle ':completion:*:(ssh|scp|rsync):*' users
