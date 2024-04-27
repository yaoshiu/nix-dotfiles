{ pkgs, ... }:
{
  home.packages = with pkgs; [ swiProlog ];
}
