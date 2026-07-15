{
  lib,
  config,
  ...
}:
{
  # zsh — ported from the old homesick .zshrc / .zsh_aliases / .zsh_functions /
  # .zsh_plugins. Plugin management moves from the system antidote
  # (/usr/share/zsh-antidote) to nix's antidote via programs.zsh.antidote.
  #
  # Generation order home-manager produces (relevant bits):
  #   500  init-early.zsh  (PATH + fzf-history-search vars, before plugins load)
  #   550  antidote        (source antidote + load plugins)
  #   570  completionInit  (compinit, now AFTER plugins so their completions register)
  #   910  HISTSIZE/SAVEHIST/HISTFILE   (from programs.zsh.history)
  #   950  history setopts              (from programs.zsh.history)
  #  1000  init.zsh        (env, setopt extras, bindkeys, _evalcache, functions)
  #  1100  shellAliases
  #
  # init-early.zsh / init.zsh are read verbatim (readFile) to preserve the heavy
  # shell escaping in MANPAGER and FZF_DEFAULT_OPTS byte-for-byte.
  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory; # keep ~/.zshrc (not ~/.config/zsh)

    antidote = {
      enable = true;
      plugins = [
        "ohmyzsh/ohmyzsh path:lib"
        "ohmyzsh/ohmyzsh path:plugins/command-not-found"
        "crisidev/evalcache"
        "zsh-users/zsh-completions"
        "belak/zsh-utils path:completion"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-history-substring-search"
        "joshskidmore/zsh-fzf-history-search"
        "hlissner/zsh-autopair"
        # zdharma org was deleted in 2021; zdharma-continuum is the maintained fork.
        "zdharma-continuum/fast-syntax-highlighting"
        "MichaelAquilina/zsh-you-should-use"
        "djui/alias-tips"
        "chr-fritz/docker-completion.zshplugin"
        "olets/zsh-window-title"
        "nix-community/nix-zsh-completions"
      ];
    };

    # Matches the old `FPATH="$HOME/.zfunc:${FPATH}"; autoload -Uz compinit; compinit`.
    completionInit = ''
      FPATH="$HOME/.zfunc:''${FPATH}"
      autoload -Uz compinit
      compinit
    '';

    # History (the old HISTFILE/HISTSIZE/SAVEHIST + setopts). Extras that this
    # option can't express (BANG_HIST, INC_APPEND_HISTORY, HIST_REDUCE_BLANKS,
    # HIST_VERIFY, HIST_BEEP) live in init.zsh.
    history = {
      size = 999999999;
      extended = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreAllDups = true;
      findNoDups = true;
      ignoreSpace = true;
      saveNoDups = true;
      share = true;
    };

    shellAliases = {
      ls = "eza";
      l = "ls -1";
      ll = "ls -lh";
      la = "ls -a";
      lt = "ls -lh -s time";
      lla = "ls -alh";
      lg = "ls -l --git";
      cp = "cp -v";
      cd = "z";
      j = "zi";
      mv = "mv -v";
      vim = "nvim";
      grepp = "grep * --color=auto -H -n -r -e ";
      grep = "grep --color=auto";
      brackets = "nl -ba $* | egrep --color=always '[{}]'";
      removeall = "sed -i /$*/d **/*(.)";
      calc = "noglob calc";
      ack = "rg -L --hidden --stats --pretty -z";
      pbc = "wl-copy"; # was `xclip -sel clip` (X11); wl-copy is native Wayland
      cat = "bat -p";
      sshpass = "ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no";
      open = "xdg-open";
      o = "xdg-open";
      userctl = "systemctl --user";
      userjournal = "journalctl --user";
      nix-shell = "nix-shell --run zsh";
      nix = "noglob nix";
      nom = "noglob nom";
      home-manager = "$HOME/.homesick/repos/dotfiles/home-manager";
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 500 (builtins.readFile ../files/zsh/init-early.zsh))
      (lib.mkOrder 1000 (builtins.readFile ../files/zsh/init.zsh))
    ];
  };
}
