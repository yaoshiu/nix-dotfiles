{ pkgs, ... }:
{
  home.packages = with pkgs; [
    joshuto
    exiftool
    file
  ];
  xdg.configFile.joshuto = {
    source = ./config;
    recursive = true;
  };
}
