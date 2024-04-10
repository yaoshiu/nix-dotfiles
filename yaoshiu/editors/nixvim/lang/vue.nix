{...}: {
  programs.nixvim = {
    plugins.lsp.servers.volar = {
      enable = true;
    };
  };
}
