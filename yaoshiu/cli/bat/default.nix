{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    themes = {
      catppuccin = {
        src = pkgs.catppuccin;
        file = "bat/Catppuccin Macchiato.tmTheme";
      };
    };

    config.theme = "catppuccin";
  };
}
