{pkgs, ...}: {
  home.packages = with pkgs; [
    vivid
  ];

  programs.zsh.initExtraFirst = ''
    export LS_COLORS="$(vivid generate catppuccin-macchiato)"
  '';

  programs.fish.interactiveShellInit = ''
    set -gx LS_COLORS (vivid generate catppuccin-macchiato)
  '';
}
