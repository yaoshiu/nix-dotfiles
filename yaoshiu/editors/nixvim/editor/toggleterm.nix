{ ... }:
{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;
      openMapping = "<C-/>";
    };

    keymaps = [
      {
        key = "<leader>ft";
        action = ''
          function()
            local term = require("toggleterm.terminal").Terminal:new({
              direction = "float",
              dir = Root(),
            })
            term:toggle()
          end
        '';
        lua = true;
        options.desc = "Terminal (root dir)";
      }

      {
        key = "<leader>fT";
        action = ''
          function()
            local term = require("toggleterm.terminal").Terminal:new({
              direction = "float",
              dir = vim.loop.cwd(),
            })
            term:toggle()
          end
        '';
        lua = true;
        options.desc = "Terminal (cwd)";
      }

      {
        key = "<C-/>";
        action = ''
          function()
            local term = require("toggleterm.terminal").Terminal:new({
              direction = "float",
              dir = Root(),
            })
            term:toggle()
          end
        '';
        lua = true;
        options.desc = "Terminal (root dir)";
      }

      {
        key = "<C-_>";
        action = ''
          function()
            local term = require("toggleterm.terminal").Terminal:new({
              direction = "float",
              dir = Root(),
            })
            term:toggle()
          end
        '';
        lua = true;
        options.desc = "whech_key_ignore";
      }

      {
        key = "<leader>gg";
        action = ''
          function()
            local term = require("toggleterm.terminal").Terminal:new({
              direction = "float",
              dir = Root(),
              cmd = "lazygit",
            })
            term:toggle()
          end
        '';
        lua = true;
        options.desc = "Lazygit (rootdir)";
      }

      {
        key = "<leader>gG";
        action = ''
          function()
            local term = require("toggleterm.terminal").Terminal:new({
              direction = "float",
              dir = vim.loop.cwd(),
              cmd = "lazygit",
            })
            term:toggle()
          end
        '';
        lua = true;
        options.desc = "Lazygit (cwd)";
      }
    ];
  };
}
