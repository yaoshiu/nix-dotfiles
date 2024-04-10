{lib, ...}: {
  networking.networkmanager.enable = true;

  networking.proxy.default = "http://192.168.110.2:7890";

  # specialisation.noProxy.configuration = {
  #   system.nixos.tags = ["Non-Proxy"];
  #   networking.proxy.default = lib.mkForce "";
  # };
}
