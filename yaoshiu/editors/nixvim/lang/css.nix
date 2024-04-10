{...}: {
  programs.nixvim.plugins = {
    lsp.servers = {
      ccls = {
        enable = true;
      };

      emmet_ls = {
        enable = true;
      };
    };
  };
}
