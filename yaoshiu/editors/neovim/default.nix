{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      wl-clipboard
      imagemagick
      clang-tools_17
      haskell-language-server
      haskellPackages.haskell-debug-adapter
      rust-analyzer
      nixfmt-rfc-style
      nixd
      tree-sitter
    ];
    extraLuaPackages = ps: with ps; [ magick ];
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
