{ pkgs, ... }: {
  home.packages = with pkgs; [
    (haskellPackages.ghcWithPackages
      (ps: with ps; [
        stack
        hoogle
        fast-tags
        ghci-dap
        haskell-debug-adapter
        haskell-language-server
      ]))
  ];
  programs.zsh.shellAliases = {
    hsc = "ghc -no-keep-hi-files -no-keep-o-files";
  };
}
