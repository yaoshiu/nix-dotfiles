{ config, ... }:
{
  hardware = {
    graphics.enable = true;
    nvidia = {
      prime.amdgpuBusId = "PCI:6:0:0";
      package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
      open = true;
    };
  };
}
