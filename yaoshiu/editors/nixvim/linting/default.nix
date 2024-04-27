{ ... }:
{
  programs.nixvim = {
    plugins = {
      lint = {
        enable = true;
        autoCmd.event = [
          "BufWritePost"
          "BufReadPost"
          "InsertLeave"
        ];
      };
    };
  };
}
