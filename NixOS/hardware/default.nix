{ ... }:
{
  imports = [
    ./audio
    ./backlight
    ./boot
    ./btrfs
    ./gpu
    ./kernel
    ./keyboard
    ./logitech
    ./network
    ./power
  ];

  hardware.enableAllFirmware = true;
}
