{ pkgs, ... }:
{
  home.packages = with pkgs; [ carapace ];

  programs.zsh.initExtraFirst = ''
    source <(carapace _carapace)
  '';
}
