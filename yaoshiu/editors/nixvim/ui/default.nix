{ pkgs, ... }:
{
  imports = [
    ./dashboard.nix
    ./bufferline.nix
    ./indent-blankline.nix
    ./lualine.nix
    ./mini-indentscope.nix
    ./noice.nix
    ./notify.nix
    ./edgy.nix
  ];

  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      dressing-nvim
      nvim-web-devicons
      nui-nvim
    ];
  };
}
