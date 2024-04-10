{...}: {
  programs.nixvim = {
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        sources = [
          {
            name = "nvim_lsp";
          }
          {
            name = "path";
          }
          {
            name = "buffer";
          }
        ];

        preselect = "cmp.PreselectMode.Item";

        formatting.format = ''
          function(_, item)
            local icons = {
              Array         = " ",
              Boolean       = "󰨙 ",
              Class         = " ",
              Codeium       = "󰘦 ",
              Color         = " ",
              Control       = " ",
              Collapsed     = " ",
              Constant      = "󰏿 ",
              Constructor   = " ",
              Copilot       = " ",
              Enum          = " ",
              EnumMember    = " ",
              Event         = " ",
              Field         = " ",
              File          = " ",
              Folder        = " ",
              Function      = "󰊕 ",
              Interface     = " ",
              Key           = " ",
              Keyword       = " ",
              Method        = "󰊕 ",
              Module        = " ",
              Namespace     = "󰦮 ",
              Null          = " ",
              Number        = "󰎠 ",
              Object        = " ",
              Operator      = " ",
              Package       = " ",
              Property      = " ",
              Reference     = " ",
              Snippet       = " ",
              String        = " ",
              Struct        = "󰆼 ",
              TabNine       = "󰏚 ",
              Text          = " ",
              TypeParameter = " ",
              Unit          = " ",
              Value         = " ",
              Variable      = "󰀫 ",
            }
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end
        '';

        mapping = let
          luasnip = "require('luasnip')";
          cmp = "require('cmp')";
        in {
          "<Tab>" = ''
            cmp.mapping(
              function(fallback)
                local has_words_before = function()
                  unpack = unpack or table.unpack
                  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
                end

                if ${cmp}.visible() then
                  ${cmp}.select_next_item()
                elseif ${luasnip}.expand_or_jumpable() then
                  ${luasnip}.expand_or_jump()
                elseif has_words_before() then
                  ${cmp}.complete()
                else
                  fallback()
                end
              end,
              {"i", "s"})
          '';

          "<S-Tab>" = ''
            cmp.mapping(
              function(fallback)
                if ${cmp}.visible() then
                  ${cmp}.select_prev_item()
                elseif ${luasnip}.jumpable(-1) then
                  ${luasnip}.jump(-1)
                else
                  fallback()
                end
              end,
              {"i", "s"})
          '';

          "<CR>" = ''
            ${cmp}.mapping({
              i = function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                  cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                else
                  fallback()
                end
              end,
              s = cmp.mapping.confirm({ select = true }),
              c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
            })
          '';
          "<C-b>" = "${cmp}.mapping.scroll_docs(-4)";

          "<C-f>" = "${cmp}.mapping.scroll_docs(4)";

          "<C-e>" = "${cmp}.mapping.abort()";

          "<C-CR>" = ''
              function(fallback)
                ${cmp}.abort()
                fallback()
            end
          '';
        };

        experimental = {
          ghost_text = {
            hl_groups = "CmpGhostText";
          };
        };

        window = {
          completion = {
            winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None";
            border = "rounded";
          };

          documentation = {
            winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None";
            border = "rounded";
          };
        };
      };
    };
  };
}
