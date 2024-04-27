{ ... }:
{
  programs.nixvim = {
    plugins.noice = {
      enable = true;
      lsp = {
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
      };

      routes = [
        {
          filter = {
            event = "msg_show";
            any = [
              { find = "%d+L, %d+B"; }
              { find = "; after #%d+"; }
              { find = "; before #%d+"; }
            ];
          };
          view = "mini";
        }
      ];

      presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
        inc_rename = true;
      };
    };

    keymaps = [
      {
        key = "<S-Enter>";
        mode = "c";
        action = ''
          function() require("noice").redirect(vim.fn.getcmdline()) end
        '';
        lua = true;
        options.desc = "Redirect Cmdline";
      }

      {
        key = "<leader>snl";
        action = ''
          function() require("noice").cmd("last") end
        '';
        lua = true;
        options.desc = "Noice Last Message";
      }

      {
        key = "<leader>snh";
        action = ''
          function() require("noice").cmd("history") end
        '';
        lua = true;
        options.desc = "Noice History";
      }

      {
        key = "<leader>sna";
        action = ''
          function() require("noice").cmd("all") end
        '';
        lua = true;
        options.desc = "Noice All";
      }

      {
        key = "<leader>snd";
        action = ''
          function() require("noice").cmd("dismiss") end
        '';
        lua = true;
        options.desc = "Dismiss All";
      }

      {
        key = "<c-f>";
        action = ''
          function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end
        '';
        lua = true;
        mode = [
          "i"
          "n"
          "s"
        ];
        options = {
          silent = true;
          expr = true;
          desc = "Scroll forward";
        };
      }

      {
        key = "<c-b>";
        action = ''
          function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end
        '';
        lua = true;
        mode = [
          "i"
          "n"
          "s"
        ];
        options = {
          silent = true;
          expr = true;
          desc = "Scroll backward";
        };
      }
    ];
  };
}
