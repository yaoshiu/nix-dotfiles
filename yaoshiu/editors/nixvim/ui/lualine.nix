{ ... }:
{
  programs.nixvim = {
    plugins.lualine = {
      enable = true;
      theme = "auto";
      globalstatus = true;
      componentSeparators = {
        left = "|";
        right = "|";
      };
      sectionSeparators = {
        left = "";
        right = "";
      };
      sections =
        let
          fg = name: ''
            function()
              local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = "${name}" }) or vim.api.nvim_get_hl_by_name("${name}", true)
              ---@diagnostic disable-next-line: undefined-field
              local fg = hl and (hl.fg or hl.foreground)
              return fg and { fg = string.format("#%06x", fg) } or nil
            end
          '';
        in
        {
          lualine_a = [
            {
              name = "mode";
              separator = {
                left = "";
              };
              padding = {
                right = 2;
                left = 0;
              };
            }
          ];

          lualine_b = [ "branch" ];

          lualine_c = [ "fileformat" ];

          lualine_x = [
            {
              name = {
                __raw = ''
                  function() return require("noice").api.status.command.get() end
                '';
              };
              extraConfig.cond = {
                __raw = ''
                  function() return require("noice").api.status.command.has() end
                '';
              };
              color = {
                __raw = fg "Statement";
              };
            }

            {
              name = {
                __raw = ''
                  function() return require("noice").api.status.mode.get() end
                '';
              };
              extraConfig.cond = {
                __raw = ''
                  function() return require("noice").api.status.mode.has() end
                '';
              };
              color = {
                __raw = fg "Constant";
              };
            }

            {
              name = {
                __raw = ''
                  function() return "  " .. require("dap").status() end
                '';
              };
              extraConfig.cond = {
                __raw = ''
                  function () return require("dap").status() ~= "" end
                '';
              };
              color = {
                __raw = fg "Debug";
              };
            }

            {
              name = "diff";
              extraConfig.symbols = {
                added = " ";
                modified = " ";
                removed = " ";
              };
              extraConfig.source = {
                __raw = ''
                  function()
                    local gitsigns = vim.b.gitsigns_status_dict
                    if gitsigns then
                      return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed,
                      }
                    end
                  end
                '';
              };
            }
          ];

          lualine_y = [
            {
              name = "progress";
              separator = {
                left = " ";
                right = " ";
              };
              padding = {
                left = 1;
                right = 1;
              };
            }
            {
              name = "location";
              padding = {
                left = 1;
                right = 1;
              };
            }
          ];

          lualine_z = [
            {
              name = {
                __raw = ''
                  function()
                    return " " .. os.date("%R")
                  end
                '';
              };
              separator = {
                right = "";
              };
              padding = {
                left = 2;
                right = 0;
              };
            }
          ];
        };

      inactiveSections = {
        lualine_a = [ "filename" ];
        lualine_z = [ "location" ];
      };

      extensions = [
        "neo-tree"
        "fzf"
        "nvim-dap-ui"
        "trouble"
      ];
    };
  };
}
