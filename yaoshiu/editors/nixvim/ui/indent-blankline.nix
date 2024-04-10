{...}: {
  programs.nixvim = {
    plugins.indent-blankline = {
      enable = true;
      indent = {
        char = "│";
        tabChar = "│";
      };
      scope = {
        enabled = true;
      };
      exclude.filetypes = [
        "help"
        "alpha"
        "dashboard"
        "neo-tree"
        "Trouble"
        "trouble"
        "lazy"
        "mason"
        "notify"
        "toggleterm"
        "lazyterm"
      ];
    };
  };
}
