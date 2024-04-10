{ pkgs
, lib
, ...
}: {
  fileSystems."/efi".options = [ "umask=0077" ];

  boot = {
    plymouth.enable = true;
    initrd.systemd.enable = true;

    loader = {
      systemd-boot.enable = lib.mkForce false;

      grub2-theme = {
        enable = true;
        theme = "whitesur";
        screen = "2k";
      };

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
  };
}
