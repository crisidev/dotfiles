{ ... }: {
  programs.zathura = {
    enable = true;
    extraConfig = ''
      set adjust-open "best-fit"
      set selection-clipboard clipboard
    '';
  };
}
