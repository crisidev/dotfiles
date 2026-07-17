{ ... }:
{
  # Starship prompt — ported 1:1 from the old homesick home/.config/starship.toml.
  # home-manager renders settings → ~/.config/starship.toml. Shell init still comes
  # from .zshrc (`_evalcache starship init zsh`), which is why zsh integration is
  # left off here — programs.zsh isn't managed by home-manager.
  programs.starship = {
    enable = true;
    enableZshIntegration = false;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      add_newline = false;
      command_timeout = 1000;

      format = "[❯](red)[❯](yellow)[❯](green) $hostname$directory";
      right_format =
        "$git_branch$git_state$git_status$git_commit$hg_branch$package$cmake$dart"
        + "$deno$dotnet$elixir$elm$erlang$gradle$golang$helm$java$julia$kotlin$meson"
        + "$nim$nodejs$ocaml$perl$php$purescript$python$ruby$rust$red$scala$swift"
        + "$terraform$vlang$vagrant$nix_shell$zig$lua$crystal$custom$battery"
        + "$cmd_duration$jobs$status";

      hostname = {
        ssh_symbol = " ";
        disabled = false;
        format = "on [$hostname](bold) ";
        ssh_only = true;
        trim_at = ".";
      };

      cmd_duration = {
        min_time = 1000;
        format = "took [$duration](bold yellow) ";
      };

      directory = {
        read_only = " 󰌾";
        truncation_length = 50;
        truncate_to_repo = false;
        truncation_symbol = "…/";
        style = "blue";
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      git_branch = {
        style = "bold yellow";
        symbol = " ";
        format = "[$symbol$branch]($style) ";
      };

      git_commit = {
        style = "normal";
        only_detached = true;
        tag_disabled = false;
        tag_symbol = "  ";
        format = "\\[[$hash](bold green)[$tag](bold red)\\] ";
      };

      git_status = {
        style = "normal";
        conflicted = "[ ](bold red)";
        ahead = "[↑×\${count}](bold green)";
        diverged = "[↑×\${ahead_count}](bold green) [↓×\${behind_count}](bold red)";
        behind = "↓×\${count}(bold red)";
        stashed = "[⊙](bold purple)";
        staged = "[](bold blue)";
        untracked = "[](normal)";
        deleted = "[](bold red)";
        modified = "[](#FF7F00)";
      };

      line_break.disabled = true;

      package = {
        symbol = "󰏗 ";
        format = "is [$symbol$version]($style) ";
      };

      status = {
        disabled = false;
        map_symbol = false;
        format = "errno [$status]($style)";
      };

      rust.symbol = "󱘗 ";
      java.symbol = " ";
      python.symbol = " ";
      kotlin.symbol = " ";
      ruby.symbol = " ";
      golang.symbol = " ";
      lua.symbol = " ";
      php.symbol = " ";
      perl.symbol = " ";
      nim.symbol = "󰆥 ";
      nodejs.symbol = " ";
      ocaml.symbol = " ";
      scala.symbol = " ";
      zig.symbol = " ";
      crystal.symbol = " ";
      elixir.symbol = " ";
      aws.symbol = "  ";
      buf.symbol = " ";
      c.symbol = " ";
      conda.symbol = " ";
      dart.symbol = " ";
      docker_context.symbol = " ";
      elm.symbol = " ";
      fennel.symbol = " ";
      fossil_branch.symbol = " ";
      guix_shell.symbol = " ";
      haskell.symbol = " ";
      haxe.symbol = " ";
      hg_branch.symbol = " ";
      julia.symbol = " ";
      memory_usage.symbol = "󰍛 ";
      meson.symbol = "󰔷 ";
      nix_shell.symbol = " ";
      pijul_channel.symbol = " ";
      rlang.symbol = "󰟔 ";
      swift.symbol = " ";
      gradle.symbol = " ";

      os.symbols = {
        Alpaquita = " ";
        Alpine = " ";
        AlmaLinux = " ";
        Amazon = " ";
        Android = " ";
        Arch = " ";
        Artix = " ";
        CentOS = " ";
        Debian = " ";
        DragonFly = " ";
        Emscripten = " ";
        EndeavourOS = " ";
        Fedora = " ";
        FreeBSD = " ";
        Garuda = "󰛓 ";
        Gentoo = " ";
        HardenedBSD = "󰞌 ";
        Illumos = "󰈸 ";
        Kali = " ";
        Linux = " ";
        Mabox = " ";
        Macos = " ";
        Manjaro = " ";
        Mariner = " ";
        MidnightBSD = " ";
        Mint = " ";
        NetBSD = " ";
        NixOS = " ";
        OpenBSD = "󰈺 ";
        openSUSE = " ";
        OracleLinux = "󰌷 ";
        Pop = " ";
        Raspbian = " ";
        Redhat = " ";
        RedHatEnterprise = " ";
        RockyLinux = " ";
        Redox = "󰀘 ";
        Solus = "󰠳 ";
        SUSE = " ";
        Ubuntu = " ";
        Unknown = " ";
        Void = " ";
        Windows = "󰍲 ";
      };
    };
  };
}
