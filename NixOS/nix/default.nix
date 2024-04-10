{ ... }: {
  environment.pathsToLink = [
    "/share"
  ];
  nix = {
    settings = {
      experimental-features = [ "flakes" "nix-command" ];
      trusted-users = [ "root" ];
    };

    optimise.automatic = true;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;
}
