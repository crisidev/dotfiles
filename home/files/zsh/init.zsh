# options
setopt NO_LIST_BEEP
setopt NO_CASE_GLOB # Case insensitive globbing
setopt NUMERIC_GLOB_SORT # Be Reasonable!
setopt EXTENDED_GLOB # I don't know why I never set this before.
setopt RC_EXPAND_PARAM # hows about arrays be awesome?  (that is, frew${cool}frew has frew surrounding all the variables, not just first and last


# history (HISTFILE/HISTSIZE/SAVEHIST + most setopts come from
# programs.zsh.history; these are the extras it doesn't expose)
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
unsetopt HIST_BEEP               # Beep when accessing nonexistent history.


# history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Nix
export NIX_PATH="nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs"

# terminal
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

# source files
[ -f $HOME/.zsh_secrets ] && source $HOME/.zsh_secrets

export KUBECONFIG=$HOME/.kube/config

# direnv
if which direnv > /dev/null; then
    _evalcache direnv hook zsh
fi

# zoxide
if which zoxide > /dev/null; then
    _evalcache zoxide init zsh
fi

# starship
if which starship > /dev/null; then
    _evalcache starship init zsh
fi

# batpipe
if which batpipe > /dev/null; then
    _evalcache batpipe
fi

if which kubectl > /dev/null; then
    _evalcache kubectl completion zsh
fi

if which helm > /dev/null; then
    _evalcache helm completion zsh
fi

# carapace (multi-shell completions for 1000+ CLIs)
if which carapace > /dev/null; then
    _evalcache carapace _carapace zsh
fi

# pay-respects (`f` reruns a corrected version of your last command)
if which pay-respects > /dev/null; then
    _evalcache pay-respects zsh --alias
fi

# aws cli completer
complete -C "aws_completer" aws

# ssh complete
zstyle ':completion:*:(ssh|scp|rsync):*' ignored-patterns '*(.|:)*'
zstyle ':completion:*:(ssh|scp|rsync):*' hosts
zstyle ':completion:*:(ssh|scp|rsync):*' users

# ---- functions (ported from .zsh_functions; homeshick/weather/pass/otp dropped) ----

function timezsh() {
    for i in $(seq 1 10); do time zsh -i -c 'exit'; done
}

# Simple calculator
function calc() {
    local result=""
    result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')"
    #                       └─ default (when `--mathlib` is used) is 20
    #
    if [[ "$result" == *.* ]]; then
        # improve the output for decimal numbers
        printf "$result" |
            sed -e 's/^\./0./' `# add "0" for cases like ".5"` \
                -e 's/^-\./-0./' `# add "0" for cases like "-.5"` \
                -e 's/0*$//;s/\.$//' # remove trailing zeros
    else
        printf "$result"
    fi
    printf "\n"
}

# Disable globbing on the remote path.
alias scp='noglob scp_wrap'
function scp_wrap {
    local -a args
    local i
    for i in "$@"; do case $i in
        *:*) args+=($i) ;;
        (*) args+=(${~i}) ;;
        esac done
    command scp "${(@)args}"
}

function runbg {
    nohup $* >/dev/null 2>&1 &
}

function tzupdate {
    sudo ~/.nix-profile/bin/tzupdate "$@"
}

function btop {
    sudo ~/.nix-profile/bin/btop "$@"
}
