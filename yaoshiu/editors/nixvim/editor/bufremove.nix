{ ... }:
{
  programs.nixvim = {
    plugins.mini.modules = {
      bufremove = { };
    };

    keymaps = [
      {
        key = "<leader>bd";
        action = ''
            function()
            local bd = require("mini.bufremove").delete
            if vim.bo.modified then
              local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
              if choice == 1 then -- Yes
                vim.cmd.write()
                bd(0)
              elseif choice == 2 then -- No
                bd(0, true)
              end
            else
              bd(0)
            end
          end
        '';
        lua = true;
        options = {
          desc = "Delete Buffer";
        };
      }

      {
        key = "<leader>bD";
        action = ''
          function() require("mini.bufremove").delete(0, true) end
        '';
        lua = true;
        options = {
          desc = "Delete Buffer (Force)";
        };
      }
    ];
  };
}
