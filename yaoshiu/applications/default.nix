{ pkgs, ... }: {
  programs.firefox.enable = true;

  home.packages = with pkgs; [
    qq
    sing-box
  ];
}
