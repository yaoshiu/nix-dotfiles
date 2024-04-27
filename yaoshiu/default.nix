{
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  home = {
    username = "yaoshiu";
    stateVersion = "22.11";

    pointerCursor = lib.mkIf pkgs.stdenv.isLinux {
      name = "WhiteSur-cursors";
      package = pkgs.whitesur-cursors;
      gtk.enable = true;
    };
  };

  programs.home-manager.enable = true;

  programs.neovim.defaultEditor = true;

  imports =
    [
      ./cli
      ./editors
      ./languages
      ./shell
      ./fonts
      ./terminals
    ]
    ++ lib.optionals osConfig.nixpkgs.hostPlatform.isLinux [
      ./desktops
      ./applications
      ./gtk
      ./ime
    ];

  xdg = {
    enable = true;
    userDirs = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      createDirectories = true;
    };
  };
}
