{...}: {
  programs.nixvim = {
    plugins = {
      dap = {
        enable = true;

        extensions = {
          dap-ui = {
            enable = true;
            render.maxTypeLength = 0;
          };

          dap-virtual-text.enable = true;
        };

        signs = {
          dapStopped = {
            text = "󰁕 ";
            texthl = "DiagnosticWarn";
            linehl = "DapStoppedLine";
            numhl = "DapStoppedLine";
          };
          dapBreakpoint.text = " ";
          dapBreakpointCondition.text = " ";
          dapBreakpointRejected = {
            text = " ";
            texthl = "DiagnosticError";
          };
          dapLogPoint.text = ".>";
        };
      };

      which-key = {
        registrations = {
          "<leader>d" = {name = "+debug";};
        };
      };
    };

    highlight = {
      DapStoppedLine = {
        default = true;
        link = "Visual";
      };
    };

    extraConfigLua = ''
      local dap = require("dap")
      local dapui = require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    '';

    keymaps = [
      {
        key = "<leader>de";
        action = ''
          function() require("dapui").eval() end
        '';
        lua = true;
        options.desc = "Eval";
      }

      {
        key = "<leader>dB";
        action = ''
          function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end
        '';
        lua = true;
        options.desc = "Breakpoint with Condition";
      }

      {
        key = "<leader>db";
        action = ''
          function() require("dap").toggle_breakpoint() end
        '';
        lua = true;
        options.desc = "Toggle Breakpoint";
      }

      {
        key = "<leader>dc";
        action = ''
          function() require("dap").continue() end
        '';
        lua = true;
        options.desc = "Continue";
      }

      {
        key = "<leader>da";
        action = let
          get_args = ''
            (function (config)
              local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
              config = vim.deepcopy(config)
              ---@cast args string[]
              config.args = function()
                local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
                return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
              end
              return config
            end)
          '';
        in ''
          function() require("dap").continue({ before = ${get_args}}) end
        '';
        lua = true;
        options.desc = "Run with Args";
      }

      {
        key = "<leader>dC";
        action = ''
          function() require("dap").run_to_cursor() end
        '';
        lua = true;
        options.desc = "Run to Cursor";
      }

      {
        key = "<leader>dg";
        action = ''
          function() require("dap").goto_() end
        '';
        lua = true;
        options.desc = "Go to Line (no execute)";
      }

      {
        key = "<leader>di";
        action = ''
          function() require("dap").step_into() end
        '';
        lua = true;
        options.desc = "Step Into";
      }

      {
        key = "<leader>dj";
        action = ''
          function() require("dap").down() end
        '';
        lua = true;
        options.desc = "Down";
      }

      {
        key = "<leader>dk";
        action = ''
          function() require("dap").up() end
        '';
        lua = true;
        options.desc = "Up";
      }

      {
        key = "<leader>dl";
        action = ''
          function() require("dap").run_last() end
        '';
        lua = true;
        options.desc = "Run Last";
      }

      {
        key = "<leader>do";
        action = ''
          function() require("dap").step_out() end
        '';
        lua = true;
        options.desc = "Step Out";
      }

      {
        key = "<leader>dO";
        action = ''
          function() require("dap").step_over() end
        '';
        lua = true;
        options.desc = "Step Over";
      }

      {
        key = "<leader>dp";
        action = ''
          function() require("dap").pause() end
        '';
        lua = true;
        options.desc = "Pause";
      }

      {
        key = "<leader>dr";
        action = ''
          function() require("dap").repl.toggle() end
        '';
        lua = true;
        options.desc = "Toggle REPL";
      }

      {
        key = "<leader>ds";
        action = ''
          function() require("dap").session() end
        '';
        lua = true;
        options.desc = "Session";
      }

      {
        key = "<leader>dt";
        action = ''
          function() require("dapui").terminate() end
        '';
        lua = true;
        options.desc = "Terminate";
      }

      {
        key = "<leader>dw";
        action = ''
          function() require("dap.ui.widgets").hover() end
        '';
        lua = true;
        options.desc = "Widgets";
      }

      {
        key = "<leader>du";
        action = ''
          function() require("dapui").toggle() end
        '';
        lua = true;
        options.desc = "Dap UI";
      }

      {
        key = "<leader>de";
        action = ''
          function()
            require("dapui").eval()
          end
        '';
        mode = ["n" "v"];
        lua = true;
        options.desc = "Eval";
      }

      {
        key = "<leader>dd";
        action = ''
          function()
            local len = require("dapui.config").render.max_type_length
            len = (len == -1) and 0 or -1
            require("dapui").update_render({ max_type_length = len })
          end
        '';
        lua = true;
        options.desc = "Toggle Rendering of Types";
      }
    ];
  };
}
