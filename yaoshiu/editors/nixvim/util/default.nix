{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      persistence.enable = true;
    };

    globals.startuptime_tries = 10;

    extraPlugins = with pkgs.vimPlugins; [ vim-startuptime ];

    keymaps = [
      {
        key = "<leader>qs";
        action = ''
          require("persistence").load
        '';
        lua = true;
        options.desc = "Restore Session";
      }

      {
        key = "<leader>ql";
        action = ''
          function() require("persistence").load({ last = true }) end
        '';
        lua = true;
        options.desc = "Restore Last Session";
      }

      {
        key = "<leader>qd";
        action = ''
          require("persistence").stop
        '';
        lua = true;
        options.desc = "Don't Save Current Session";
      }
    ];
  };
}
