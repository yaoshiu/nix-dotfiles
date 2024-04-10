{ ... }: {
  environment.pathsToLink = [
    "/share"
  ];
  nix = {
    settings = {
      experimental-features = [ "flakes" "nix-command" ];
      trusted-users = [ "root" ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    optimise.automatic = true;

    gc = {
      automatic = true;
      interval = {
          Week = 1;
      };
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;
}
