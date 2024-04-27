{ pkgs, ... }:
let
  js-debug = fetchTarball {
    url = "https://github.com/microsoft/vscode-js-debug/releases/download/v1.86.1/js-debug-dap-v1.86.1.tar.gz";
    sha256 = "sha256:1h2yhdzlzp8ism3pxa9msnirym27z271yq2rywry0jpi6ggf7qrw";
  };
in
{
  programs.nixvim = {
    plugins = {
      typescript-tools = {
        enable = true;
        onAttach = "__lspOnAttach";
        settings = {
          completeFunctionCalls = true;
          tsserverFilePreferences = {
            includeInlayParameterNameHints = "all";
            # includeInlayParameterNameHintsWhenArgumentMatchesName = true;
            includeInlayFunctionParameterTypeHints = true;
            includeInlayVariableTypeHints = true;
            includeInlayVariableTypeHintsWhenTypeMatchesName = true;
            includeInlayPropertyDeclarationTypeHints = true;
            includeInlayFunctionLikeReturnTypeHints = true;
            # includeInlayEnumMemberValueHints = true;
          };
        };
      };

      dap = {
        adapters.servers = {
          pwa-node = {
            host = "localhost";
            port = "\${port}";
            executable = {
              command = "node";
              args = [
                "${js-debug}/src/dapDebugServer.js"
                "\${port}"
              ];
            };
          };
        };

        configurations =
          builtins.foldl'
            (
              acc: lang:
              acc
              // {
                "${lang}" = [
                  {
                    name = "Lauch file";
                    type = "pwa-node";
                    request = "launch";
                    program = "\${file}";
                    cwd = "\${workspaceFolder}";
                  }
                  {
                    name = "Attach";
                    type = "pwa-node";
                    request = "attach";
                    processId.__raw = "require('dap.utils').pick_process";
                    cwd = "\${workspaceFolder}";
                  }
                ];
              }
            )
            { }
            [
              "typescript"
              "javascript"
              "typescriptreact"
              "javascriptreact"
            ];
      };
    };

    extraPackages = [ pkgs.nodePackages.typescript ];
  };
}
