{...}: {
  programs.nixvim.colorschemes.catppuccin = {
    enable = true;
    flavour = "macchiato";
    terminalColors = true;
    integrations = {
      alpha = true;
      cmp = true;
      flash = true;
      gitsigns = true;
      noice = true;
      notify = true;
      symbols_outline = true;
      treesitter = true;
      native_lsp = {
        enabled = true;
        underlines = {
          errors = ["undercurl"];
          hints = ["undercurl"];
          warnings = ["undercurl"];
          information = ["undercurl"];
        };
      };
      treesitter_context = true;
      which_key = true;
      dap = {
        enabled = true;
        enable_ui = true;
      };
      illuminate = {
        enabled = true;
        lsp = true;
      };
      indent_blankline.enabled = true;
      mini.enabled = true;
      telescope.enabled = true;
      navic.enabled = true;
      NormalNvim = true;
      lsp_trouble = true;
      markdown = true;
      neotree = true;
    };
  };
}
