{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      wl-clipboard
    ];
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
