{ ... }:
{
  programs.nixvim = {
    plugins.illuminate = {
      enable = true;
      delay = 200;
      largeFileCutoff = 2000;
      largeFileOverrides.providers = [ "lsp" ];
    };

    keymaps = [
      {
        key = "]]";
        action = ''
          function()
            require("illuminate").goto_next_reference(false)
          end
        '';
        lua = true;
        options.desc = "Next Reference";
      }

      {
        key = "[[";
        action = ''
          function()
            require("illuminate").goto_prev_reference(false)
          end
        '';
        lua = true;
        options.desc = "Previous Reference";
      }
    ];
  };
}
