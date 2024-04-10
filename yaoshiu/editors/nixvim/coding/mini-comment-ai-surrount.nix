{...}: {
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      modules = {
        comment = {
          custom_commentstring = ''
            function()
              return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
            end
          '';
        };

        ai = {
          n_lines = 500;
          custom_textobjects = let
            ai = ''require("mini.ai")'';
          in {
            o = ''
              ${ai}.gen_spec.treesitter({
                a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                i = { "@block.inner", "@conditional.inner", "@loop.inner" },
              }, {})
            '';

            f = ''
              ${ai}.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {})
            '';

            c = ''
              ${ai}.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {})
            '';

            t = ["<([%p%w]-)%f[^<%w][^<>]->.-</%1>" "^<.->().*()</[^/]->$"];
          };
        };

        surround = {
          mappings = {
            add = "gsa";
            delete = "gsd";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            replace = "gsr";
            update_n_lines = "gsn";
          };
        };
      };
    };
  };
}
