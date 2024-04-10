{...}: {
  programs.nixvim = {
    plugins.bufferline = {
      enable = true;
      closeCommand = ''function(n) require("mini.bufremove").delete(n, false) end'';
      rightMouseCommand = ''function(n) require("mini.bufremove").delete(n, false) end'';
      diagnostics = "nvim_lsp";
      alwaysShowBufferline = false;
      offsets = [
        {
          filetype = "neo-tree";
          text = "Neo-tree";
          highlight = "Directory";
          text_align = "left";
        }
      ];
    };

    keymaps = [
      {
        key = "<leader>bp";
        action = "<Cmd>BufferLineTogglePin<CR>";
        options.desc = "Toggle pin";
      }

      {
        key = "<leader>bP";
        action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
        options.desc = "Delete non-pinned buffers";
      }

      {
        key = "<leader>bo";
        action = "<Cmd>BufferLineCloseOthers<CR>";
        options.desc = "Delete other buffers";
      }

      {
        key = "<leader>br";
        action = "<Cmd>BufferLineCloseRight";
        options.desc = "Delete buffers to the right";
      }

      {
        key = "<leader>bl";
        action = "<Cmd>BufferLineCloseLeft";
        options.desc = "Delete buffers to the left";
      }

      {
        key = "<S-h>";
        action = "<Cmd>BufferLineCyclePrev<CR>";
        options.desc = "Prev Buffer";
      }

      {
        key = "<S-l>";
        action = "<Cmd>BufferLineCycleNext<CR>";
        options.desc = "Next Buffer";
      }

      {
        key = "[b";
        action = "<Cmd>BuffLineCyclePrev<CR>";
        options.desc = "Prev Buffer";
      }

      {
        key = "]b";
        action = "<Cmd>BuffLineCycleNext<CR>";
        options.desc = "Next Buffer";
      }
    ];
  };
}
