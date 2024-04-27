{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ gnomeExtensions.kimpanel ];

  services.xserver = {
    enable = true;

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager.gnome = {
      enable = true;
    };
  };
}
