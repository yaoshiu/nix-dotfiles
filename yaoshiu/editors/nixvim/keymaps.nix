{ ... }:
{
  programs.nixvim = {
    extraConfigLuaPre = ''
      local diagnostic_goto = function(next, severity)
        local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
        severity = severity and vim.diagnostic.severity[severity] or nil
        return function()
          go({ severity = severity })
        end
      end

      local Format = setmetatable({}, {
        __call = function(m, ...)
          return m.format(...)
        end,
      })

      ---@class LazyFormatter
      ---@field name string
      ---@field primary? boolean
      ---@field format fun(bufnr:number)
      ---@field sources fun(bufnr:number):string[]
      ---@field priority number

      Format.formatters = {} ---@type LazyFormatter[]

      ---@param formatter LazyFormatter
      function Format.register(formatter)
        Format.formatters[#Format.formatters + 1] = formatter
        table.sort(Format.formatters, function(a, b)
          return a.priority > b.priority
        end)
      end

      function Format.formatexpr()
        return require("conform").formatexpr()
      end

      ---@param buf? number
      ---@return (LazyFormatter|{active:boolean,resolved:string[]})[]
      function Format.resolve(buf)
        buf = buf or vim.api.nvim_get_current_buf()
        local have_primary = false
        ---@param formatter LazyFormatter
        return vim.tbl_map(function(formatter)
          local sources = formatter.sources(buf)
          local active = #sources > 0 and (not formatter.primary or not have_primary)
          have_primary = have_primary or (active and formatter.primary) or false
          return setmetatable({
            active = active,
            resolved = sources,
          }, { __index = formatter })
        end, Format.formatters)
      end

      ---@param buf? number
      function Format.info(buf)
        buf = buf or vim.api.nvim_get_current_buf()
        local gaf = vim.g.autoformat == nil or vim.g.autoformat
        local baf = vim.b[buf].autoformat
        local enabled = Format.enabled(buf)
        local lines = {
          "# Status",
          ("- [%s] global **%s**"):format(gaf and "x" or " ", gaf and "enabled" or "disabled"),
          ("- [%s] buffer **%s**"):format(
            enabled and "x" or " ",
            baf == nil and "inherit" or baf and "enabled" or "disabled"
          ),
        }
        local have = false
        for _, formatter in ipairs(Format.resolve(buf)) do
          if #formatter.resolved > 0 then
            have = true
            lines[#lines + 1] = "\n# " .. formatter.name .. (formatter.active and " ***(active)***" or "")
            for _, line in ipairs(formatter.resolved) do
              lines[#lines + 1] = ("- [%s] **%s**"):format(formatter.active and "x" or " ", line)
            end
          end
        end
        if not have then
          lines[#lines + 1] = "\n***No formatters available for this buffer.***"
        end
      end

      ---@param buf? number
      function Format.enabled(buf)
        buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
        local gaf = vim.g.autoformat
        local baf = vim.b[buf].autoformat

        -- If the buffer has a local value, use that
        if baf ~= nil then
          return baf
        end

        -- Otherwise use the global value if set, or true by default
        return gaf == nil or gaf
      end

      ---@param buf? boolean
      function Format.toggle(buf)
        if buf then
          vim.b.autoformat = not Format.enabled()
        else
          vim.g.autoformat = not Format.enabled()
          vim.b.autoformat = nil
        end
        Format.info()
      end

      ---@param opts? {force?:boolean, buf?:number}
      function Format.format(opts)
        opts = opts or {}
        local buf = opts.buf or vim.api.nvim_get_current_buf()
        if not ((opts and opts.force) or Format.enabled(buf)) then
          return
        end

        local done = false
        for _, formatter in ipairs(Format.resolve(buf)) do
          if formatter.active then
            done = true
            return formatter.format(buf)
          end
        end
      end

      function Format.setup()
        -- Autoformat autocmd
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("LazyFormat", {}),
          callback = function(event)
            Format.format({ buf = event.buf })
          end,
        })

        -- Formatanual format
        vim.api.nvim_create_user_command("LazyFormat", function()
          Format.format({ force = true })
        end, { desc = "Format selection or buffer" })

        -- Format info
        vim.api.nvim_create_user_command("LazyFormatInfo", function()
          Format.info()
        end, { desc = "Show info about the formatters for the current buffer" })
      end
    '';

    keymaps = [
      #For Leader mapping
      {
        key = "<Space>";
        action = "<Nop>";
        mode = [
          "n"
          "v"
        ];
        options.silent = true;
      }

      #Butter Up/Down
      {
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        mode = [
          "n"
          "x"
        ];
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        key = "<Down>";
        action = "v:count == 0 ? 'gj' : 'j'";
        mode = [
          "n"
          "x"
        ];
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        mode = [
          "n"
          "x"
        ];
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        key = "<Up>";
        action = "v:count == 0 ? 'gk' : 'k'";
        mode = [
          "n"
          "x"
        ];
        options = {
          expr = true;
          silent = true;
        };
      }

      #Move to Window Using the <CTRL> HJKL Keys
      {
        key = "<C-h>";
        action = "<C-w>h";
        mode = "n";
        options = {
          desc = "Go to Left Window";
          remap = true;
        };
      }
      {
        key = "<C-j>";
        action = "<C-w>j";
        mode = "n";
        options = {
          desc = "Go to Lower Window";
          remap = true;
        };
      }
      {
        key = "<C-k>";
        action = "<C-w>k";
        mode = "n";
        options = {
          desc = "Go to Upper Window";
          remap = true;
        };
      }
      {
        key = "<C-l>";
        action = "<C-w>l";
        mode = "n";
        options = {
          desc = "Go to Right Window";
          remap = true;
        };
      }

      #Resize Window Using <CTRL> Arrow Keys
      {
        key = "<C-Up>";
        action = "<cmd>resize +2<cr>";
        mode = "n";
        options.desc = "Increase Window Height";
      }
      {
        key = "<C-Down>";
        action = "<cmd>resize -2<cr>";
        mode = "n";
        options.desc = "Decrease Window Height";
      }
      {
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        mode = "n";
        options.desc = "Increase Window Width";
      }
      {
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        mode = "n";
        options.desc = "Decrease Window Width";
      }

      # Move Lines
      {
        key = "<A-j>";
        action = "<cmd>m .+1<CR>==";
        mode = "n";
        options.desc = "Move Line Down";
      }
      {
        key = "<A-k>";
        action = "<cmd>m .-2<CR>==";
        mode = "n";
        options.desc = "Move Line Up";
      }
      {
        key = "<A-j>";
        action = "<esc><cmd>m .+1<CR>==gi";
        mode = "i";
        options.desc = "Move Line Down";
      }
      {
        key = "<A-k>";
        action = "<esc><cmd>m .-2<CR>==gi";
        mode = "i";
        options.desc = "Move Line Up";
      }
      {
        key = "<A-j>";
        action = "<cmd>m '>+1<cr>gv=gv";
        mode = "v";
        options.desc = "Move Line Down";
      }
      {
        key = "<A-k>";
        action = "<cmd>m '<-2<cr>gv=gv";
        mode = "v";
        options.desc = "Move Line Up";
      }

      # Buffers
      {
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        mode = "n";
        options.desc = "Prev Buffer";
      }
      {
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        mode = "n";
        options.desc = "Next Buffer";
      }
      {
        key = "[b";
        action = "<cmd>bprevious<cr>";
        mode = "n";
        options.desc = "Prev Buffer";
      }
      {
        key = "]b";
        action = "<cmd>bnext<cr>";
        mode = "n";
        options.desc = "Next Buffer";
      }
      {
        key = "<leader>bb";
        action = "<cmd>e #<cr>";
        mode = "n";
        options.desc = "Switch to Other Buffer";
      }
      {
        key = "<leader>`";
        action = "<cmd>e #<cr>";
        mode = "n";
        options.desc = "Switch to Other Buffer";
      }

      # Clear Search With <ESC>
      {
        key = "<esc>";
        action = "<cmd>noh<cr><esc>";
        mode = [
          "n"
          "i"
        ];
        options.desc = "Escape and Clear Search";
      }

      # Clear Search, Diff Update and Redraw
      # Open from Runtime/Lua/_editor.lua
      {
        key = "<leader>ur";
        action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
        mode = "n";
        options.desc = "Redraw / Clear Hlsearch / Diff Update";
      }

      # https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
      {
        key = "n";
        action = "'Nn'[v:searchforward].'zv'";
        mode = "n";
        options = {
          expr = true;
          desc = "Next Search Result";
        };
      }
      {
        key = "n";
        action = "'Nn'[v:searchforward]";
        mode = [
          "x"
          "o"
        ];
        options = {
          expr = true;
          desc = "Next Search Result";
        };
      }
      {
        key = "N";
        action = "'nN'[v:searchforward].'zv'";
        mode = "n";
        options = {
          expr = true;
          desc = "Previous Search Result";
        };
      }
      {
        key = "N";
        action = "'nN'[v:searchforward]";
        mode = [
          "x"
          "o"
        ];
        options = {
          expr = true;
          desc = "Previous Search Result";
        };
      }

      # Add Undo Break-points
      {
        key = ",";
        action = ",<c-g>u";
        mode = "i";
      }
      {
        key = ".";
        action = ".<c-g>u";
        mode = "i";
      }
      {
        key = ";";
        action = ";<c-g>u";
        mode = "i";
      }

      # Save File
      {
        key = "<C-s>";
        action = "<cmd>w<cr><esc>";
        mode = [
          "i"
          "x"
          "n"
          "s"
        ];
        options.desc = "Save File";
      }

      # Keywordprg
      {
        key = "<leader>K";
        action = "<cmd>norm! K<cr>";
        mode = "n";
        options.desc = "Keywordprg";
      }

      # Better Indenting
      {
        key = "<";
        action = "<gv";
        mode = "v";
      }
      {
        key = ">";
        action = ">gv";
        mode = "v";
      }

      # New File
      {
        key = "<leader>fn";
        action = "<cmd>enew<cr>";
        mode = "n";
        options.desc = "New File";
      }

      {
        key = "<leader>xl";
        action = "<cmd>lopen<cr>";
        mode = "n";
        options.desc = "Location List";
      }
      {
        key = "<leader>xq";
        action = "<cmd>copen<cr>";
        mode = "n";
        options.desc = "Quickfix List";
      }

      {
        key = "[q";
        action = "vim.cmd.cprev";
        lua = true;
        mode = "n";
        options.desc = "Prev Quickfix";
      }
      {
        key = "]q";
        action = "vim.cmd.cnext";
        lua = true;
        mode = "n";
        options.desc = "Next Quickfix";
      }
      {
        key = "[l";
        action = "vim.cmd.lprev";
        lua = true;
        mode = "n";
        options.desc = "Prev Location";
      }
      {
        key = "]l";
        action = "vim.cmd.lnext";
        lua = true;
        mode = "n";
        options.desc = "Next Location";
      }

      # Formatting
      {
        key = "<leader>cf";
        action = ''
          function()
            Format({ force = true })
          end
        '';
        lua = true;
        mode = [
          "n"
          "v"
        ];
        options.desc = "Format";
      }

      # Diagnostic
      {
        key = "<leader>cd";
        action = "vim.diagnostic.open_float";
        lua = true;
        mode = "n";
        options.desc = "Line Diagnostics";
      }
      {
        key = "]d";
        action = "diagnostic_goto(true)";
        lua = true;
        mode = "n";
        options.desc = "Next Diagnostic";
      }
      {
        key = "[d";
        action = "diagnostic_goto(false)";
        lua = true;
        mode = "n";
        options.desc = "Prev Diagnostic";
      }
      {
        key = "]e";
        action = "diagnostic_goto(true, 'ERROR')";
        lua = true;
        mode = "n";
        options.desc = "Next Error";
      }
      {
        key = "[e";
        action = "diagnostic_goto(false, 'ERROR')";
        lua = true;
        mode = "n";
        options.desc = "Prev Error";
      }
      {
        key = "]w";
        action = "diagnostic_goto(true, 'WARN')";
        lua = true;
        mode = "n";
        options.desc = "Next Warning";
      }
      {
        key = "[w";
        action = "diagnostic_goto(false, 'WARN')";
        lua = true;
        mode = "n";
        options.desc = "Prev Warning";
      }

      # Toggle Options
      {
        key = "<leader>uf";
        action = ''
          function()
            vim.g.autoformat = not vim.g.autoformat
            vim.b.autoformat = nil
          end
        '';
        lua = true;
        mode = "n";
        options.desc = "Toggle Auto Format (Global)";
      }
      {
        key = "<leader>uF";
        action = ''
          function()
            vim.b.autoformat = not vim.b.autoformat
          end
        '';
        lua = true;
        mode = "n";
        options.desc = "Toggle Auto Format (Buffer)";
      }
      {
        key = "<leader>us";
        action = ''
          function()
            vim.opt_local.spell = not vim.opt_local.spell
          end
        '';
        lua = true;
        mode = "n";
        options.desc = "Toggle Spelling";
      }
      {
        key = "<leader>uw";
        action = ''
          function()
            vim.opt_local.wrap = not vim.opt_local.wrap
          end
        '';
        lua = true;
        mode = "n";
        options.desc = "Toggle Word Wrap";
      }
      {
        key = "<leader>uL";
        action = ''
          function()
            vim.opt_local.relativenumber = not vim.opt_local.relativenumber
          end
        '';
        lua = true;
        mode = "n";
        options.desc = "Toggle Relative Line Numbers";
      }
      {
        key = "<leader>ul";
        action = ''
          function()
            vim.opt_local.number = not vim.opt_local.number
          end
        '';
        lua = true;
        mode = "n";
        options.desc = "Toggle Line Numbers";
      }
      {
        key = "<leader>ud";
        action = ''
          function()
            -- if this Neovim version supports checking if diagnostics are enabled
            -- then use that for the current state
            if vim.diagnostic.is_disabled then
              enabled = not vim.diagnostic.is_disabled()
            end
            enabled = not enabled

            if enabled then
              vim.diagnostic.enable()
            else
              vim.diagnostic.disable()
            end
          end
        '';
        lua = true;
        mode = "n";
        options.desc = "Toggle Diagnostics";
      }
      {
        key = "<leader>uc";
        action = ''
          function()
            local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
            vim.o.conceallevel = conceallevel == 3 and 0 or 3
          end
        '';
        lua = true;
        mode = "n";
        options.desc = "Toggle Conceal";
      }
      {
        key = "<leader>uh";
        action = ''
          function(buf, value)
            local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
            if type(ih) == "function" then
              ih(buf, value)
            elseif type(ih) == "table" and ih.enable then
              if value == nil then
                value = not ih.is_enabled(buf)
              end
              ih.enable(buf, value)
            end
          end
        '';
        lua = true;
        mode = "n";
        options.desc = "Toggle Inlay Hints";
      }
      {
        key = "<leader>ub";
        action = ''
          function()
            vim.opt_local.background = vim.opt_local.background == "dark" and "light" or "dark"
          end
        '';
        lua = true;
        mode = "n";
        options.desc = "Toggle Background";
      }

      # Quit
      {
        key = "<leader>qq";
        action = "<cmd>qa<cr>";
        mode = "n";
        options.desc = "Quit all";
      }

      # Highlights under Cursor
      {
        key = "<leader>ui";
        action = "vim.show_pos";
        lua = true;
        mode = "n";
        options.desc = "Inspect Pos";
      }

      # Terminal Mappings
      {
        key = "<esc><esc>";
        action = "<c-\\><c-n>";
        mode = "t";
        options.desc = "Enter Normal Mode";
      }
      {
        key = "<C-h>";
        action = "<cmd>wincmd h<cr>";
        mode = "t";
        options.desc = "Go to Left Window";
      }
      {
        key = "<C-j>";
        action = "<cmd>wincmd j<cr>";
        mode = "t";
        options.desc = "Go to Lower Window";
      }
      {
        key = "<C-k>";
        action = "<cmd>wincmd k<cr>";
        mode = "t";
        options.desc = "Go to Upper Window";
      }
      {
        key = "<C-l>";
        action = "<cmd>wincmd l<cr>";
        mode = "t";
        options.desc = "Go to Right Window";
      }
      {
        key = "<C-/>";
        action = "<cmd>close<cr>";
        mode = "t";
        options.desc = "Hide Terminal";
      }
      {
        key = "<C-_>";
        action = "<cmd>close<cr>";
        mode = "t";
        options.desc = "Hide Terminal";
      }

      # Windows
      {
        key = "<leader>ww";
        action = "<C-W>p";
        mode = "n";
        options = {
          remap = true;
          desc = "Other Window";
        };
      }
      {
        key = "<leader>wd";
        action = "<C-W>c";
        mode = "n";
        options = {
          remap = true;
          desc = "Delete Window";
        };
      }
      {
        key = "<leader>w-";
        action = "<C-W>s";
        mode = "n";
        options = {
          remap = true;
          desc = "Split Window below";
        };
      }
      {
        key = "<leader>w|";
        action = "<C-W>v";
        mode = "n";
        options = {
          remap = true;
          desc = "Split Window right";
        };
      }
      {
        key = "<leader>-";
        action = "<C-W>s";
        mode = "n";
        options = {
          remap = true;
          desc = "Split Window below";
        };
      }
      {
        key = "<leader>|";
        action = "<C-W>v";
        mode = "n";
        options = {
          remap = true;
          desc = "Split Window right";
        };
      }

      # Tabs
      {
        key = "<leader><tab>l";
        action = "<cmd>tablast<cr>";
        mode = "n";
        options.desc = "Last Tab";
      }
      {
        key = "<leader><tab>f";
        action = "<cmd>tabfirst<cr>";
        mode = "n";
        options.desc = "First Tab";
      }
      {
        key = "<leader><tab><tab>";
        action = "<cmd>tabnew<cr>";
        mode = "n";
        options.desc = "New Tab";
      }
      {
        key = "<leader><tab>]";
        action = "<cmd>tabnext<cr>";
        mode = "n";
        options.desc = "Next Tab";
      }
      {
        key = "<leader><tab>d";
        action = "<cmd>tabclose<cr>";
        mode = "n";
        options.desc = "Close Tab";
      }
      {
        key = "<leader><tab>[";
        action = "<cmd>tabprevious<cr>";
        mode = "n";
        options.desc = "Prev Tab";
      }

      # Copy & Paste from system clipboard
      {
        key = "<c-s-v>";
        action = ''
          function ()
          	vim.api.nvim_paste(vim.fn.getreg('+'), true, -1)
          end
        '';
        mode = [
          "i"
          "c"
          "t"
        ];
        lua = true;
      }
      {
        key = "<C-S-c>";
        action = "\"+y";
        mode = [
          "n"
          "v"
        ];
      }
      {
        key = "<C-S-v>";
        action = "\"+p";
        mode = [
          "n"
          "v"
        ];
      }
    ];
  };
}
