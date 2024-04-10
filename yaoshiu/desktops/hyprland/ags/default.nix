{
  pkgs,
  config,
  ...
}: {
  programs.ags = {
    enable = true;
    configDir = ./config;
    extraPackages = with pkgs; [
      bun
      sassc
      libdbusmenu-gtk3
    ];
  };

  home.packages = config.programs.ags.extraPackages;

  wayland.windowManager.hyprland.settings = {
    decoration.blurls = [
      "bar"
    ];
  };
}
