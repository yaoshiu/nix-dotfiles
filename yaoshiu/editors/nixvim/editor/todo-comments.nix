{ ... }:
{
  programs.nixvim = {
    plugins.todo-comments = {
      enable = true;
      keymaps = {
        todoTrouble = {
          key = "<leader>xt";
          options.desc = "Todo (Trouble)";
        };

        todoTelescope = {
          key = "<leader>st";
          options.desc = "Todo (Telescope)";
        };
      };
    };

    keymaps = [
      {
        key = "]t";
        action = ''
          require("todo-comments").jump_next
        '';
        lua = true;
        options.desc = "Next todo comment";
      }

      {
        key = "[t";
        action = ''
          require("todo-comments").jump_prev
        '';
        lua = true;
        options.desc = "Previous todo comment";
      }

      {
        key = "<leader>xt";
        action = "<cmd>TodoTrouble<cr>";
        options.desc = "Todo (Trouble)";
      }

      {
        key = "<leader>xT";
        action = "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>";
        options.desc = "Todo/Fix/Fixme (Trouble)";
      }

      {
        key = "<leader>st";
        action = "<cmd>TodoTelescope<cr>";
        options.desc = "Todo";
      }

      {
        key = "<leader>sT";
        action = "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>";
        options.desc = "Todo/Fix/Fixme";
      }
    ];
  };
}
