{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      conform-nvim = {
        enable = true;

        formatOnSave = {
          timeoutMs = 3000;
          lspFallback = true;
        };

        formattersByFt = {
          lua = [ "stylua" ];
          sh = [ "shfmt" ];
          fish = [ "fish_indent" ];
          rust = [ "rustfmt" ];
        };

        formatters = {
          injected.options.ignore_errors = true;
          rustfmt.args = [
            "--edition"
            "2021"
          ];
        };
      };
    };

    extraPackages = with pkgs; [
      shfmt
      stylua
      rustfmt
    ];

    keymaps = [
      {
        key = "<leader>cF";
        action = ''
          function()
            require("conform").format({ formatters = { "injected" } })
          end
        '';
        mode = [
          "n"
          "v"
        ];
        lua = true;
        options.desc = "Format Injected Langs";
      }
    ];
  };
}
