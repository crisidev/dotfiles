{ ... }:
{
  # tmux — ported from home/.config/tmux/tmux.conf (TokyoNight Storm). The status
  # bar uses powerline glyphs, so the config is passed byte-for-byte via extraConfig
  # (readFile). `terminal` and `escapeTime` are set here so home-manager's injected
  # baseline agrees with the config instead of fighting it (escape-time is set with
  # `-s` in the baseline vs `-g` in the file, so pinning it avoids any scope skew).
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    escapeTime = 0;
    extraConfig = builtins.readFile ../files/tmux/tmux.conf;
  };
}
