{...}: {
  programs.nixvim = {
    plugins.notify = {
      enable = true;
      timeout = 3000;
      maxHeight = {
        __raw = ''
          function()
            return math.floor(vim.o.lines * 0.75)
          end
        '';
      };

      maxWidth = {
        __raw = ''
          function()
            return math.floor(vim.o.columns * 0.75)
          end
        '';
      };

      onOpen = ''
        function(win)
          vim.api.nvim_win_set_config(win, { zindex = 100 })
        end
      '';
    };

    keymaps = [
      {
        key = "<leader>un";
        action = ''
          function()
            require("notify").dismiss({ silent = true, pending = true })
          end
        '';
        lua = true;
        options.desc = "Dismiss all Notifications";
      }
    ];
  };
}
