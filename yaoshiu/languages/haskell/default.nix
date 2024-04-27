{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (haskellPackages.ghcWithPackages (
      ps: with ps; [
        stack
        hoogle
        fast-tags
      ]
    ))
  ];
}
