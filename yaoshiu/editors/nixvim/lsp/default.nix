{ pkgs, ... }: {
  imports = [
    ./fidget.nix
  ];

  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;

        servers = {
          nixd.enable = false;
          nil_ls = {
            enable = true;
            extraOptions = {
              settings.nil.nix.flake.autoArchive = true;
            };
          };
        };

        onAttach = ''
          local keymaps = {
            { lhs = "<leader>cl", rhs = "<cmd>LspInfo<cr>", opts = {desc = "Lsp Info" }},
            { lhs = "gd", rhs = function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, opts = {desc = "Goto Definition"}},
            { lhs = "gr", rhs = "<cmd>Telescope lsp_references<cr>", opts = { desc = "References" } },
            { lhs = "gD", rhs = vim.lsp.buf.declaration, opts = { desc = "Goto Declaration" } },
            { lhs = "gy", rhs = function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, opts = {desc = "Goto T[y]pe Definition"} },
            { lhs = "gI", rhs = function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, opts = {desc = "Goto Implementation" }},
            { lhs = "K", rhs = vim.lsp.buf.hover, opts = { desc = "Hover" } },
            { lhs = "gK", rhs = vim.lsp.buf.signature_help, opts = { desc = "Signature Help" } },
            { lhs = "<c-k>", rhs = vim.lsp.buf.signature_help, mode = "i", opts = { desc = "Signature Help" } },
            { lhs = "<leader>ca", rhs = vim.lsp.buf.code_action, opts = { desc = "Code Action" }, mode = { "n", "v" } },
            {
              lhs = "<leader>cA",
              rhs = function()
                vim.lsp.buf.code_action({
                  context = {
                    only = {
                      "source",
                    },
                    diagnostics = {},
                  },
                })
              end,
              opts = {desc = "Source Action"},
            },
            { lhs = "<leader>cr", rhs = vim.lsp.buf.rename, opts = { desc = "Rename" } },
          }

          for _, keys in pairs(keymaps) do
            vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, keys.opts)
          end
        '';
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      neoconf-nvim
    ];
  };
}
