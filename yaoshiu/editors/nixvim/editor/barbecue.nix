{ ... }:
{
  programs.nixvim = {
    plugins = {
      barbecue = {
        enable = true;
        attachNavic = true;
        customSection = ''
          function()
            return {{" ", "WinBar"}}
          end
        '';
      };

      navic = {
        enable = true;
        separator = " ";
        highlight = true;
        depthLimit = 5;
        lazyUpdateContext = true;
        lsp = {
          autoAttach = true;
          preference = [ "nil_ls" ];
        };
        icons = {
          Array = " ";
          Boolean = "󰨙 ";
          Class = " ";
          Constant = "󰏿 ";
          Constructor = " ";
          Enum = " ";
          EnumMember = " ";
          Event = " ";
          Field = " ";
          File = " ";
          Function = "󰊕 ";
          Interface = " ";
          Key = " ";
          Method = "󰊕 ";
          Module = " ";
          Namespace = "󰦮 ";
          Null = " ";
          Number = "󰎠 ";
          Object = " ";
          Operator = " ";
          Package = " ";
          Property = " ";
          String = " ";
          Struct = "󰆼 ";
          TypeParameter = " ";
          Variable = "󰀫 ";
        };
      };
    };
  };
}
