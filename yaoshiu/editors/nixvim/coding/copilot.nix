{ ... }: {
  programs.nixvim = {
    plugins = {
      copilot-lua = {
        enable = true;
        filetypes = {
          markdown = true;
          help = true;
        };

        suggestion = {
          enabled = true;
          autoTrigger = true;
        };

        panel.enabled = true;
      };
    };
  };
}
