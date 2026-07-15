{ ... }:
{
  # topgrade — ported 1:1 from home/.config/topgrade.toml.
  programs.topgrade = {
    enable = true;
    settings = {
      misc = {
        set_title = true;
        display_time = true;
        disable = [
          "home_manager"
          "pnpm"
          "poetry"
          "snap"
          "toolbx"
          "uv"
        ];
        ignore_failures = [ "git_repos" ];
      };

      git = {
        max_concurrency = 5;
        # NOTE: several of these are stale now — the gnome-shell-extensions
        # (mouse-follows-focus, pop-shell, gnome-github-manager) are GNOME-era,
        # and Tokyonight-GTK-Theme is unused since GTK moved to Orchis-Nord via
        # nix. Left as-is for a faithful port; trim whenever you like.
        repos = [
          "~/.homesick/repos/homeshick"
          "~/.homesick/repos/dotfiles"
          "~/.homesick/repos/lazyvim"
          "~/github/gnome-shell-extensions/mouse-follows-focus"
          "~/github/gnome-shell-extensions/pop-shell"
          "~/github/gnome-shell-extensions/gnome-github-manager"
          "~/github/Tokyonight-GTK-Theme"
        ];
        arguments = "--ff-only --rebase --autostash";
      };

      python.enable_pip_review = true;
    };
  };
}
