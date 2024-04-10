{ ... }: {
  imports = [
    ./coding
    ./editor
    ./formatting
    ./linting
    ./lsp
    ./treesitter
    ./ui
    ./util
    ./dap
    ./lang

    ./options.nix
    ./colorscheme.nix
    ./keymaps.nix
    ./autocmds.nix
  ];

  programs.nixvim = {
    enable = true;

    luaLoader.enable = true;

    clipboard.providers = {
      wl-copy.enable = true;
    };
  };
}
