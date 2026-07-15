{ ... }:
{
  # bat — ported from home/.config/bat. The old setup linked the whole TokyoNight
  # theme tree and selected "tokyonight_storm" via ~/.config/bat/config. bat keys
  # themes by FILENAME (every file's internal name is just "TokyoNight"), so each
  # variant is provided as bat/themes/<name>.tmTheme. home-manager runs
  # `bat cache --build` on activation, then --theme=tokyonight_storm resolves.
  # Theme files live byte-intact under home-nix/files/bat/ (moved out of homesick).
  programs.bat = {
    enable = true;
    config.theme = "tokyonight_storm";
    themes = {
      tokyonight_day = {
        src = ../files/bat;
        file = "tokyonight_day.tmTheme";
      };
      tokyonight_moon = {
        src = ../files/bat;
        file = "tokyonight_moon.tmTheme";
      };
      tokyonight_night = {
        src = ../files/bat;
        file = "tokyonight_night.tmTheme";
      };
      tokyonight_storm = {
        src = ../files/bat;
        file = "tokyonight_storm.tmTheme";
      };
    };
  };
}
