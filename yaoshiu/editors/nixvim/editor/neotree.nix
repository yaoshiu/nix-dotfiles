{lib, ...}: {
  programs.nixvim = {
    plugins.neo-tree = {
      enable = true;

      sources = [
        "filesystem"
        "buffers"
        "git_status"
        "document_symbols"
      ];

      extraOptions = {
        open_files_do_not_replace_types = lib.mkDefault [
          "terminal"
          "Trouble"
          "trouble"
          "qf"
          "Outline"
        ];
      };

      defaultComponentConfigs.indent = {
        withExpanders = true;
        expanderCollapsed = "";
        expanderExpanded = "";
        expanderHighlight = "NeoTreeExpander";
      };
    };
    keymaps = [
      {
        key = "<leader>fe";
        action = ''
          function()
            require("neo-tree.command").execute({ toggle = true, dir = Root() })
          end
        '';
        lua = true;
        options.desc = "Explore NeoTree (project root)";
      }

      {
        key = "<leader>e";
        action = "<leader>fe";
        options = {
          desc = "Explore NeoTree (project root)";
          remap = true;
        };
      }

      {
        key = "<leader>fE";
        action = ''
          function()
            require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
          end
        '';
        lua = true;
        options.desc = "Explore NeoTree (current dir)";
      }

      {
        key = "<leader>E";
        action = "<leader>fE";
        options = {
          desc = "Explore NeoTree (current dir)";
          remap = true;
        };
      }

      {
        key = "<leader>ge";
        action = ''
          function()
            require("neo-tree.command").execute({ source = "git_status", toggle = true })
          end
        '';
        lua = true;
        options.desc = "Git explorer";
      }

      {
        key = "<leader>be";
        action = ''
          function()
            require("neo-tree.command").execute({ source = "buffers", toggle = true })
          end
        '';
        lua = true;
        options.desc = "Buffers explorer";
      }
    ];
  };
}
