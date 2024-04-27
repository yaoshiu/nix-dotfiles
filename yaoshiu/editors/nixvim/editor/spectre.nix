{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.nvim-spectre ];

    extraConfigLua = ''
      require('spectre').setup({
        open_cmd = "noswapfile vnew"
      })
    '';

    keymaps = [
      {
        key = "<leader>sr";
        action = ''
          require('spectre').open
        '';
        lua = true;
        options.desc = "Replace in files (Spectre)";
      }
    ];
  };
}
