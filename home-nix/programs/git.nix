{ ... }:
{
  # Git — ported 1:1 from the old homesick home/.config/git/{config,gitattributes,
  # gitignore}. Uses the current programs.git schema (settings = freeform gitconfig;
  # the old userName/aliases/extraConfig options are deprecated aliases of it).
  # delta is still provided by each host's package list (not delta.enable) so the
  # exact per-command pager + interactive.diffFilter from the old config survive.
  programs.git = {
    enable = true;

    # Global gitignore (was core.excludesfile → ~/.config/git/gitignore).
    # home-manager writes ~/.config/git/ignore (git's XDG default), so no
    # core.excludesFile key is needed.
    ignores = [
      "# Automatically created by GitHub for Mac"
      "# To make edits, delete these initial comments, or else your changes may be lost!"
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "# Icon must end with two \\r"
      "Icon"
      "# Thumbnails"
      "._*"
      "# Files that might appear in the root of a volume"
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      "# Directories potentially created on remote AFP share"
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"
      ".__mypy_cache__"
      ".idea"
      ".envrc"
      ".sdkmanrc"
      ".bacon-locations"
      ".coverage"
      ".direnv"
      ".claude"
      "**/.claude/settings.local.json"
    ];

    # Global gitattributes (was core.attributesfile → ~/.config/git/gitattributes),
    # written to ~/.config/git/attributes (git's XDG default).
    attributes = [
      "*.java merge=mergiraf"
      "*.rs merge=mergiraf"
      "*.go merge=mergiraf"
      "*.js merge=mergiraf"
      "*.jsx merge=mergiraf"
      "*.json merge=mergiraf"
      "*.yml merge=mergiraf"
      "*.yaml merge=mergiraf"
      "*.html merge=mergiraf"
      "*.htm merge=mergiraf"
      "*.xhtml merge=mergiraf"
      "*.xml merge=mergiraf"
      "*.c merge=mergiraf"
      "*.h merge=mergiraf"
      "*.cc merge=mergiraf"
      "*.cpp merge=mergiraf"
      "*.hpp merge=mergiraf"
      "*.cs merge=mergiraf"
      "*.dart merge=mergiraf"
    ];

    # Freeform gitconfig (replaces the deprecated userName/userEmail/aliases/extraConfig).
    settings = {
      user = {
        name = "Matteo Bigoi";
        email = "bigo@crisidev.org";
        signingKey = "099F4F3AA10B27C97B746F03AEFBBD3BE8C66E4A";
        signingEmail = "bigo@crisidev.org";
      };

      commit.gpgSign = true;

      alias = {
        dag = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'";
        dagall = "log --all --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'";
        lg = "log --graph --format='format:%C(yellow)%h%C(reset) %C(blue)<%ae>%C(reset) %C(magenta)%ai%C(reset)%C(auto)%d%C(reset) %s' --date-order";
        st = "status";
        cm = "commit";
        co = "checkout";
        cob = "checkout -b";
        df = "diff";
        sh = "show";
        ps = "push";
        pl = "pull";
        pulf = "pull --ff-only";
        pulfa = "pull --ff-only --autostash";
        pulr = "pull --rebase";
        fix = "commit -s --amend";
        afix = "commit -s -a --amend";
        acm = ''!f(){ git add -A && msg=$(git diff --cached | claude --model haiku -p 'summarize into commit message, using https://www.conventionalcommits.org/en/v1.0.0/, explaining the change and why it has been done, max 20 lines + title. use bullet points that are gitea friendly. the commit message should be between ``` ```') && git commit -s -e -m "$msg"; };f'';
        rb = ''!r(){ count=$1;git branch --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset)|%(color:red)%(objectname:short)%(color:reset)|%(contents:subject)|%(authorname) (%(color:green)%(committerdate:relative)%(color:reset))' --color=always | head -n ''${count:=20} | column -ts'|'; };r'';
      };

      color = {
        ui = "auto";
        branch = {
          current = "yellow reverse";
          local = "yellow";
          remote = "green";
        };
        status = {
          added = "yellow";
          changed = "green";
          untracked = "cyan";
        };
      };

      pager = {
        diff = "delta";
        log = "delta";
        reflog = "delta";
        show = "delta";
      };

      status.submoduleSummary = true;
      interactive.diffFilter = "delta --color-only --features=interactive";

      push = {
        default = "upstream";
        autoSetupRemote = true;
      };
      pull.rebase = true;
      credential.helper = "store";
      help.autocorrect = 20;
      init.defaultBranch = "main";

      delta = {
        features = "decorations";
        # Plain values (no literal quotes): home-manager quotes the whole value
        # when writing the file, so the '#' is protected from git's comment
        # parsing while delta still receives `syntax #3f2d3d`.
        minus-style = "syntax #3f2d3d";
        minus-non-emph-style = "syntax #3f2d3d";
        minus-emph-style = "syntax #763842";
        minus-empty-line-marker-style = "syntax #3f2d3d";
        line-numbers-minus-style = "#914c54";
        plus-style = "syntax #283b4d";
        plus-non-emph-style = "syntax #283b4d";
        plus-emph-style = "syntax #316172";
        plus-empty-line-marker-style = "syntax #283b4d";
        line-numbers-plus-style = "#449dab";
        line-numbers-zero-style = "#3b4261";
        whitespace-error-style = "22 reverse";
        decorations = {
          commit-decoration-style = "bold yellow box";
          file-style = "bold blue ul";
          file-decoration-style = "none";
          hunk-header-style = "omit";
        };
      };

      url = {
        "ssh://git@github.com/".insteadOf = "https://github.com/";
        "ssh://git@code.crisidev.org:2022/".insteadOf = "https://code.crisidev.org/";
      };

      merge.mergiraf = {
        name = "mergiraf";
        driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P";
      };
    };
  };
}
