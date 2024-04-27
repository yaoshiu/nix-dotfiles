{ ... }:
{
  programs.nixvim = {
    extraConfigLuaPre = ''
      Telescope = setmetatable({}, {
        __call = function(m, ...)
          return m.telescope(...)
        end,
      })
      function Telescope.telescope(builtin, opts)
        local params = { builtin = builtin, opts = opts }
        return function()
          builtin = params.builtin
          opts = params.opts
          opts = vim.tbl_deep_extend("force", { cwd = Root() }, opts or {}) --[[@as lazyvim.util.telescope.opts]]
          if builtin == "files" then
            if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
              opts.show_untracked = true
              builtin = "git_files"
            else
              builtin = "find_files"
            end
          end
          if opts.cwd and opts.cwd ~= vim.loop.cwd() then
            ---@diagnostic disable-next-line: inject-field
            opts.attach_mappings = function(_, map)
              map("i", "<a-c>", function()
                local action_state = require("telescope.actions.state")
                local line = action_state.get_current_line()
                Telescope.telescope(
                  params.builtin,
                  vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line })
                )()
              end)
              return true
            end
          end

          require("telescope.builtin")[builtin](opts)
        end
      end

      function Telescope.config_files()
        return Telescope("find_files", { cwd = vim.fn.stdpath("config") })
      end

        function get_kind_filter(buf)
          kind_filter = {
            default = {
              "Class",
              "Constructor",
              "Enum",
              "Field",
              "Function",
              "Interface",
              "Method",
              "Module",
              "Namespace",
              "Package",
              "Property",
              "Struct",
              "Trait",
            },
            markdown = false,
            help = false,
            -- you can specify a different filter for each filetype
            lua = {
              "Class",
              "Constructor",
              "Enum",
              "Field",
              "Function",
              "Interface",
              "Method",
              "Module",
              "Namespace",
              -- "Package", -- remove package since luals uses it for control flow structures
              "Property",
              "Struct",
              "Trait",
            },
          }
          buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
          local ft = vim.bo[buf].filetype
          if kind_filter == false then
            return
          end
          if kind_filter[ft] == false then
            return
          end
          ---@diagnostic disable-next-line: return-type-mismatch
          return type(kind_filter) == "table" and type(kind_filter.default) == "table" and kind_filter.default or nil
        end
    '';

    plugins.telescope = {
      enable = true;
      defaults = {
        prompt_prefix = " ";
        selection_caret = " ";
        get_selection_widow = {
          __raw = ''
            function()
              local wins = vim.api.nvim_list_wins()
              table.insert(wins, 1, vim.api.nvim_get_current_win())
              for _, win in ipairs(wins) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].buftype == "" then
                  return win
                end
              end
              return 0
            end
          '';
        };
        mappings =
          let
            actions = ''
              (require("telescope.actions"))
            '';
            flash = ''
              function (prompt_bufnr)
                require("flash").jump({
                  pattern = "^",
                  label = { after = { 0, 0 } },
                  search = {
                    mode = "search",
                    exclude = {
                      function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                      end,
                    },
                  },
                  action = function(match)
                    local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                    picker:set_selection(match.pos[1] - 1)
                  end,
                })
              end
            '';
          in
          {
            i = {
              "<c-t>" = {
                __raw = ''
                  function(...)
                    return require("trouble.providers.telescope").open_with_trouble(...)
                  end
                '';
              };

              "<a-t>" = {
                __raw = ''
                  function(...)
                    return require("trouble.providers.telescope").open_selected_with_trouble(...)
                  end
                '';
              };

              "<a-i>" = {
                __raw = ''
                  function()
                    local action_state = require("telescope.actions.state")
                    local line = action_state.get_current_line()
                    Telescope("find_files", { no_ignore = true, default_text = line })()
                  end
                '';
              };

              "<a-h>" = {
                __raw = ''
                  function()
                    local action_state = require("telescope.actions.state")
                    local line = action_state.get_current_line()
                    Telescope("find_files", { hidden = true, default_text = line })()
                  end
                '';
              };

              "<C-Down>" = {
                __raw = ''
                  ${actions}.cycle_history_next
                '';
              };

              "<C-Up>" = {
                __raw = ''
                  ${actions}.cycle_history_prev
                '';
              };

              "<C-f>" = {
                __raw = ''
                  ${actions}.preview_scrolling_down
                '';
              };

              "<C-b>" = {
                __raw = ''
                  ${actions}.preview_scrolling_up
                '';
              };

              "<c-s>" = {
                __raw = flash;
              };
            };

            n = {
              q = {
                __raw = ''
                  ${actions}.close
                '';
              };

              s = {
                __raw = flash;
              };
            };
          };
      };

      keymaps = {
        "<leader>:" = {
          action = "command_history";
          desc = "Command History";
        };
        "<leader>sk" = {
          action = "keymaps";
          desc = "Key Maps";
        };
        "<leader>sC" = {
          action = "commands";
          desc = "Commands";
        };
        "<leader>fr" = {
          action = "oldfiles";
          desc = "Recent";
        };
        "<leader>gc" = {
          action = "git_commits";
          desc = "Commits";
        };
        "<leader>gs" = {
          action = "git_status";
          desc = "Status";
        };
        "<leader>s\"" = {
          action = "registers";
          desc = "Registers";
        };
        "<leader>sa" = {
          action = "autocommands";
          desc = "Auto Commands";
        };
        "<leader>sb" = {
          action = "current_buffer_fuzzy_find";
          desc = "Buffer";
        };
        "<leader>sc" = {
          action = "command_history";
          desc = "Command History";
        };
        "<leader>sD" = {
          action = "diagnostics";
          desc = "Workspace Diagnostics";
        };
        "<leader>sh" = {
          action = "help_tags";
          desc = "Help Pages";
        };
        "<leader>sH" = {
          action = "highlights";
          desc = "Search Hihglight Groups";
        };
        "<leader>sm" = {
          action = "marks";
          desc = "Jump to Mark";
        };
        "<leader>sM" = {
          action = "man_pages";
          desc = "Man Pages";
        };
        "<leader>so" = {
          action = "vim_options";
          desc = "Options";
        };
        "<leader>sR" = {
          action = "resume";
          desc = "Resume";
        };
      };

      extensions = {
        fzf-native.enable = true;
      };
    };

    keymaps = [
      {
        key = "<leader>,";
        action = "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>";
        options.desc = "Switch Buffer";
      }

      {
        key = "<leader>/";
        action = ''
          Telescope("live_grep")
        '';
        lua = true;
        options.desc = "Grep (root dir)";
      }

      {
        key = "<leader><space>";
        action = ''
          Telescope("files")
        '';
        lua = true;
        options.desc = "Find File (root dir)";
      }

      {
        key = "<leader>fb";
        action = "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>";
        options.desc = "Buffers";
      }

      {
        key = "<leader>fc";
        action = ''
          Telescope.config_files()
        '';
        lua = true;
        options.desc = "Config files";
      }

      {
        key = "<leader>ff";
        action = ''
          Telescope("files")
        '';
        lua = true;
        options.desc = "Find Files (rood dir)";
      }

      {
        key = "<leader>fF";
        action = ''
          Telescope("files", {cwd = false})
        '';
        lua = true;
        options.desc = "Find Files (cwd)";
      }

      {
        key = "<leader>fR";
        action = ''
          Telescope("oldfiles", {cwd = vim.loop.cwd()})
        '';
        lua = true;
        options.desc = "Recent (cwd)";
      }

      {
        key = "<leader>sd";
        action = "<cmd>Telescope diagnostics bufnr=0<cr>";
        options.desc = "Document Diagnostics";
      }

      {
        key = "<leader>sg";
        action = ''
          Telescope("live_grep")
        '';
        lua = true;
        options.desc = "Grep (root dir)";
      }

      {
        key = "<leader>sG";
        action = ''
          Telescope("live_grep", {cwd = false})
        '';
        lua = true;
        options.desc = "Grep (cwd)";
      }

      {
        key = "<leader>sw";
        action = ''
          Telescope("grep_string", { word_match = "-w" })
        '';
        lua = true;
        options.desc = "Word (root dir)";
      }

      {
        key = "<leader>sW";
        action = ''
          Telescope("grep_string", { word_match = "-w", cwd = false })
        '';
        lua = true;
        options.desc = "Word (cwd)";
      }

      {
        key = "<leader>sw";
        action = ''
          Telescope("grep_string")
        '';
        mode = "v";
        lua = true;
        options.desc = "Selection (root dir)";
      }

      {
        key = "<leader>sW";
        action = ''
          Telescope("grep_string", { cwd = false })
        '';
        mode = "v";
        lua = true;
        options.desc = "Selection (cwd)";
      }

      {
        key = "<leader>uC";
        action = ''
          Telescope("colorscheme", {enable_preview = true})
        '';
        lua = true;
        options.desc = "Colorscheme with Preview";
      }

      {
        key = "<leader>ss";
        action = ''
          function()
            require("telescope.builtin").lsp_document_symbols({
              symbols = get_kind_filter(),
            })
          end
        '';
        lua = true;
        options.desc = "Goto Symbol";
      }

      {
        key = "<leader>sS";
        action = ''
          function()
            require("telescope.builtin").lsp_dynamic_workspace_symbols({
                symbols = get_kind_filter(),
            })
          end
        '';
        lua = true;
        options.desc = "Goto Symbol (Workspace)";
      }
    ];
  };
}
