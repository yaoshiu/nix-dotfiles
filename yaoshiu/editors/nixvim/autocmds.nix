{ ... }:
{
  programs.nixvim = rec {
    autoGroups = builtins.foldl' (
      acc: cmd: acc // (if builtins.hasAttr "group" cmd then { ${cmd.group} = { }; } else { })
    ) { } autoCmd;

    autoCmd = [
      # Check if we neet to reload the file when it changed
      {
        event = [
          "FocusGained"
          "TermClose"
          "TermLeave"
        ];
        command = "checktime";
        group = "checktime";
      }

      # Hghlght on yank
      {
        event = "TextYankPost";
        callback.__raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
        group = "highlight_yank";
      }

      # Resize splits if window got resized
      {
        event = "VimResized";
        callback.__raw = ''
          function()
            local current_tab = vim.fn.tabpagenr()
            vim.cmd("tabdo wincmd =")
            vim.cmd("tabnext " .. current_tab)
          end
        '';
        group = "resize_splits";
      }

      # Close some filetypes with <q>
      {
        event = "FileType";
        pattern = [
          "PlenaryTestPopup"
          "help"
          "lspinfo"
          "man"
          "notify"
          "qf"
          "query"
          "spectre_panel"
          "startuptime"
          "tsplayground"
          "neotest-output"
          "checkhealth"
          "neotest-summary"
          "neotest-output-panel"
        ];
        callback.__raw = ''
          function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
          end
        '';
        group = "close_with_q";
      }

      # Wrap and check for spell in text filetypes
      {
        event = "FileType";
        pattern = [
          "gitcommit"
          "markdown"
          "neorg"
        ];
        callback.__raw = ''
          function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = true
          end
        '';
        group = "wrap_spell";
      }

      # Fix Conceallevel for json files
      {
        event = "FileType";
        pattern = [
          "json"
          "jsonc"
          "json5"
        ];
        callback.__raw = ''
          function()
            vim.opt_local.conceallevel = 0
          end
        '';
        group = "json_conceal";
      }

      # Auto create dir when saving a file, in case some intermediate directory does not exist
      {
        event = "BufWritePre";
        callback.__raw = ''
          function(event)
            if event.match:match("^%w%w+://") then
              return
            end
            local file = vim.loop.fs_realpath(event.match) or event.match
            vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
          end
        '';
        group = "auto_create_dir";
      }
    ];
  };
}
