{pkgs, ...}: {
  programs.nixvim = {
    plugins.luasnip = {
      enable = true;
      extraConfig = {
        history = true;
        delete_check_events = "TextChanged";
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      friendly-snippets
    ];
  };
}
