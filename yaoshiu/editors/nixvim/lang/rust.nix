{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      rustaceanvim = {
        enable = true;
        dap.adapter = ''
          function ()
            local extension_path = "${
              with pkgs;
              if stdenv.isDarwin then
                vscode-marketplace.vadimcn.vscode-lldb
              else
                vscode-extensions.vadimcn.vscode-lldb
            }/share/vscode/extensions/vadimcn.vscode-lldb/"
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb${
              if pkgs.stdenv.isDarwin then ".dylib" else ".so"
            }"

            local cfg = require("rustaceanvim.config")
            return cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
          end
        '';
        server = {
          onAttach = ''
            function(client, bufnr)
              __lspOnAttach(client, bufnr)
              vim.keymap.set("n", "<leader>cR", function() vim.cmd.RustLsp("codeAction") end,
                { desc = "Code Action", buffer = bufnr })
              vim.keymap.set("n", "<leader>dr", function() vim.cmd.RustLsp("debuggables") end,
                { desc = "Rust debuggables", buffer = bufnr })
            end
          '';

          standalone = true;

          settings = {
            cargo = {
              buildScripts.enable = true;
              autoreload = true;
              features = "all";
            };

            checkOnSave = true;

            check = {
              overrideCommand = [ "clippy" ];
              extraArgs = [ "--no-deps" ];
              features = "all";
            };

            procMacro = {
              enable = true;
              ignored = {
                async-trait = [ "async_trait" ];
                napi-derive = [ "napi" ];
                async-recursion = [ "async_recursion" ];
              };
            };
          };
        };
      };

      crates-nvim = {
        enable = true;
        extraOptions = {
          src.cmp.enabled = true;
        };
      };

      cmp.settings.sources = [ { name = "crates"; } ];

      lsp.servers = {
        taplo = {
          enable = true;
          onAttach.function = ''
            vim.keymap.set("n", "K", function()
              if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                require("crates").show_popup()
              else
                vim.lsp.buf.hover()
              end
            end, {buffer = bufnr, desc = "Show Crate Documentation"})
          '';
        };
      };
    };

    extraPackages = with pkgs; [ lldb ];
  };
}
