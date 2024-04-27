{ pkgs, config, ... }:
{
  sops.secrets."password/yaoshiu@NixOS".neededForUsers = true;

  users.users.yaoshiu = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "docker"
      "network"
    ];
    hashedPasswordFile = config.sops.secrets."password/yaoshiu@NixOS".path;
  };

  nix.settings.trusted-users = [ "yaoshiu" ];
}
