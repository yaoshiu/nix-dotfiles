{...}: {
  programs.nixvim = {
    plugins.nix-develop.enable = true;
  };
}
