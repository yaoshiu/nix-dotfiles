{...}: {
  programs.nixvim = {
    plugins.flash = {
      enable = true;
      search = {
        mode = "search";
      };
      modes = {
        search = {
          enabled = false;
        };
      };
    };

    keymaps = [
      {
        key = "s";
        action = "require('flash').jump";
        lua = true;
        mode = ["n" "x" "o"];
        options = {
          desc = "Flash";
        };
      }

      {
        key = "S";
        action = "require('flash').treesitter";
        lua = true;
        mode = ["n" "x" "o"];
        options = {
          desc = "Flash";
        };
      }

      {
        key = "r";
        action = "require('flash').remote";
        lua = true;
        mode = "o";
        options = {
          desc = "Remote Flash";
        };
      }

      {
        key = "R";
        action = "require('flash').treesitter_search";
        lua = true;
        mode = ["o" "x"];
        options = {
          desc = "Treesitter Search";
        };
      }

      {
        key = "<c-s>";
        action = "require('flash').toggle";
        lua = true;
        mode = "c";
        options = {
          desc = "Toggle Flash Search";
        };
      }
    ];
  };
}
