{pkgs, ...}: {
  programs.bat = {
    enable = true;
    themes = {
      catppuccin = {
        src = pkgs.catppuccin;
        file = "bat/Catppuccin-macchiato.tmTheme";
      };
    };

    config.theme = "catppuccin";
  };
}
