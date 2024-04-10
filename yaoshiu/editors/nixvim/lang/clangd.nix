{ pkgs, ... }: {
  programs.nixvim = {
    plugins = {
      clangd-extensions = {
        enable = true;
        inlayHints.inline = "true";
        enableOffsetEncodingWorkaround = true;
        ast = {
          roleIcons = {
            type = "";
            declaration = "";
            expression = "";
            specifier = "";
            statement = "";
            templateArgument = "";
          };

          kindIcons = {
            compound = "";
            recovery = "";
            translationUnit = "";
            packExpansion = "";
            templateTypeParm = "";
            templateTemplateParm = "";
            templateParamObject = "";
          };
        };
      };

      cmp.settings.sorting.comparators = [
        "require('cmp.config.compare').offset"
        "require('clangd_extensions.cmp_scores')"
        "require('cmp.config.compare').exact"
        "require('cmp.config.compare').score"
        "require('cmp.config.compare').recently_used"
        "require('cmp.config.compare').locality"
        "require('cmp.config.compare').kind"
        "require('cmp.config.compare').length"
        "require('cmp.config.compare').order"
      ];

      lsp.servers.clangd = {
        enable = true;
        extraOptions = {
          root_dir = {
            __raw = ''
              function(fname)
                return require("lspconfig.util").root_pattern(
                  "Makefile",
                  "configure.ac",
                  "configure.in",
                  "config.h.in",
                  "meson.build",
                  "meson_options.txt",
                  "build.ninja"
                )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
                  fname
                ) or require("lspconfig.util").find_git_ancestor(fname)
              end
            '';
          };
          init_options = {
            usePlaceholders = true;
            completeUnimported = true;
            clangdFileStatus = true;
          };
        };
        onAttach.function = ''
          vim.keymap.set("n", "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", {
            desc = "Switch Source/Header (C/C++)",
            buffer = bufnr})
        '';
      };

      dap = {
        adapters =
          # if pkgs.stdenv.isLinux then {
          #   executables = {
          #     cppdbg = {
          #       command =
          #         let
          #           cpptools = pkgs.vscode-marketplace.ms-vscode.cpptools.overrideAttrs (old: {
          #             postFixup = ''
          #               chmod +x $out/share/vscode/extensions/ms-vscode.cpptools/debugAdapters/bin/OpenDebugAD7
          #             '';
          #           });
          #         in
          #         "${cpptools}/share/vscode/extensions/ms-vscode.cpptools/debugAdapters/bin/OpenDebugAD7";
          #       id = "cppdbg";
          #     };
          #   };
          # } else 
          {
            servers = {
              cppdbg = {
                port = "\${port}";
                executable = {
                  command = "${with pkgs; if stdenv.isDarwin then vscode-marketplace.vadimcn.vscode-lldb else vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
                  args = [ "--port" "\${port}" ];
                };
              };
            };
          };
        configurations = rec {
          cpp = [
            {
              name = "Launch";
              type = "cppdbg";
              request = "launch";
              program.__raw = ''
                 function()
                  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end
              '';
              cwd = "\${workspaceFolder}";
              stopAtEntry = false;
            }
          ];

          c = cpp;
        };
      };
    };
  };
}
