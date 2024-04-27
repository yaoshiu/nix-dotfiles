{ pkgs, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    settings = {
      format = "$all";
      palette = "catppuccin_macchiato";
    } // (builtins.fromTOML (builtins.readFile "${pkgs.catppuccin}/starship/macchiato.toml"));
  };
}
