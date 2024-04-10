{...}: {
  programs.nixvim = {
    plugins.which-key = {
      enable = true;

      triggers = "auto";

      operators = {
        "gsa" = "Add surrounding";
        "gsd" = "Delete surrounding";
        "gsf" = "Find right surrounding";
        "gsF" = "Find left surrounding";
        "gsh" = "Highlight surrounding";
        "gsr" = "Replace surrounding";
      };
      registrations = {
        mode = ["n" "v"];
        "g" = {name = "+goto";};
        "gs" = {name = "+surround";};
        "gsn" = "Update `MiniSurround.config.n_lines`";
        "]" = {name = "+next";};
        "[" = {name = "+prev";};
        "<leader><tab>" = {name = "+tabs";};
        "<leader>b" = {name = "+buffer";};
        "<leader>c" = {name = "+code";};
        "<leader>f" = {name = "+file/find";};
        "<leader>g" = {name = "+git";};
        "<leader>gh" = {name = "+hunks";};
        "<leader>q" = {name = "+quit/session";};
        "<leader>s" = {name = "+search";};
        "<leader>u" = {name = "+ui";};
        "<leader>w" = {name = "+windows";};
        "<leader>x" = {name = "+diagnostics/quickfix";};
      };
    };
  };
}
