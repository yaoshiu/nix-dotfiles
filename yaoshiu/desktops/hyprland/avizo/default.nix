{...}: {
  services.avizo = {
    enable = true;
    settings = {
      default = {
        y-offset = 0.5;
        background = "rgba(255, 255, 255, 0.3)";
        border-width = 0;
        bar-fg-color = "rgba(27, 27, 29, 0.8)";
      };
    };
  };

  wayland.windowManager.hyprland.settings = {
    decoration.blurls = [
      "avizo"
    ];
  };
}
