{pkgs, ...}: {
  home.packages = [
    pkgs.nwg-dock-hyprland
  ];

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "nwg-dock-hyprland -d -hd 0"
    ];
  };

  xdg.configFile.nwg-dock-hyprland = {
    source = ./config;
    recursive = true;
  };
}
