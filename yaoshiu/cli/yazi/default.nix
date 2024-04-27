{ pkgs, ... }:
{
  programs = {
    yazi = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
    jq.enable = true;
    ripgrep.enable = true;
    fzf.enable = true;
    zoxide.enable = true;
  };

  home.packages = with pkgs; [
    unar
    ffmpegthumbnailer
    poppler
    fd
  ];
}
