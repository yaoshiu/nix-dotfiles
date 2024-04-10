{ ... }: {
  programs.nixvim = {

    plugins = {
      treesitter = {
        enable = true;
        folding = true;
        indent = true;
        nixvimInjections = true;
        incrementalSelection = {
          enable = true;
          keymaps = {
            initSelection = "<C-space>";
            nodeIncremental = "<C-space>";

            nodeDecremental = "<bs>";
          };
        };
      };

      treesitter-textobjects = {
        enable = true;
        move = {
          enable = true;
          gotoNextStart = {
            "]f" = "@function.outer";
            "]c" = "@class.outer";
          };

          gotoNextEnd = {
            "]F" = "@function.outer";
            "]C" = "@class.outer";
          };

          gotoPreviousStart = {
            "[f" = "@function.outer";
            "[c" = "@class.ouver";
          };

          gotoPreviousEnd = {
            "[F" = "@function.outer";
            "[C" = "@class.outer";
          };
        };
      };

      treesitter-context = {
        enable = true;
        maxLines = 3;
      };

      ts-autotag.enable = true;
    };
  };
}
