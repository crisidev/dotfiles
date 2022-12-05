# antigen
export ANTIGEN_LOG=/tmp/antigen.log
source $HOME/.cache/antigen.zsh

antigen use oh-my-zsh

antigen bundle command-not-found
antigen bundle fd
antigen bundle history
antigen bundle web-search

antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zaw

export ZSH_FZF_HISTORY_SEARCH_BIND="^f"
export ZSH_FZF_HISTORY_SEARCH_FZF_ARGS="+s +m +x -e --height 40% --reverse"
antigen bundle joshskidmore/zsh-fzf-history-search

antigen bundle hlissner/zsh-autopair
antigen bundle supercrabtree/k
antigen bundle --branch=main zdharma/fast-syntax-highlighting
antigen bundle MichaelAquilina/zsh-you-should-use
# antigen bundle --branch=main marlonrichert/zsh-autocomplete
antigen bundle mafredri/zsh-async
antigen bundle djui/alias-tips

antigen apply

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
unsetopt HIST_BEEP                 # Beep when accessing nonexistent history.

# history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# source files
[ -f $HOME/.zsh_aliases ] && source $HOME/.zsh_aliases
[ -f $HOME/.zsh_amzn ] && source $HOME/.zsh_amzn
[ -f $HOME/.zsh_functions ] && source $HOME/.zsh_functions
[ -f $HOME/.zsh_secrets ] && source $HOME/.zsh_secrets

# paths
CUSTOM_PATH=$HOME/.local/share/nvim/mason/bin:$HOME/.bin:$HOME/.toolbox/bin
CUSTOM_PATH=$CUSTOM_PATH:$HOME/.pyenv/bin:$HOME/.rbenv/bin:$HOME/.nodenv/bin:$HOME/.goenv/bin
CUSTOM_PATH=$CUSTOM_PATH:$HOME/.pyenv/shims:$HOME/.rbenv/shims:$HOME/.nodenv/shims:$HOME/.goenv/shims
CUSTOM_PATH=$CUSTOM_PATH:$HOME/.cargo/bin:$HOME/.config/rofi/scripts
export PATH=$CUSTOM_PATH:$PATH

# # terminal
export TERMINFO=/usr/share/terminfo
export GREP_COLOR='1;31'
export VISUAL=vim
export EDITOR=vim
export PAGER=less

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
  export PATH=$PATH:$HOME/.nodenv/versions/18.12.0/bin
fi

# goenv
export GOENV_ROOT="$HOME/.goenv"
if which goenv > /dev/null; then 
  export GOENV_GOPATH_PREFIX=$HOME/.go
  eval "$(goenv init -)" 
  export PATH=$PATH:$GOPATH/bin
  export GOPROXY=direct
fi

# sshrc
compdef sshrc=ssh

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude build'

# zoxide
eval "$(zoxide init zsh)"

# bw
export RUSTC_WRAPPER=$HOME/.cargo/bin/sccache

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# spaceship
eval "$(starship init zsh)"
