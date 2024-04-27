{ ... }:
{
  programs.nixvim = {
    plugins.nvim-autopairs = {
      enable = true;
      checkTs = true;
    };

    extraConfigLua =
      let
        cmp_autopairs = "require('nvim-autopairs.completion.cmp')";
        cmp = "require('cmp')";
      in
      ''
        ${cmp}.event:on('confirm_done', ${cmp_autopairs}.on_confirm_done());
      '';
  };
}
