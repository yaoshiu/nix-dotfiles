{ ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      theme = "mine";
    };
    themes.mine = {
      inherits = "tokyonight_moon";
      "ui.virtual.jump-label" = {
        fg = "default";
        bg = "red";
      };
    };
  };
}
