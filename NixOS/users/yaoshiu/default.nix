{ pkgs, config, ... }: {
  sops.secrets."password/yaoshiu@NixOS".neededForUsers = true;

  users.users.yaoshiu = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "docker" "network" ];
    shell = pkgs.fish;
    hashedPasswordFile = config.sops.secrets."password/yaoshiu@NixOS".path;
  };

  nix.settings.trusted-users = [ "yaoshiu" ];
}
