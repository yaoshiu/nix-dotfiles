{ pkgs, ... }:
let
  wluma = pkgs.wluma.overrideAttrs (
    self: prev: {
      postInstall =
        prev.postInstall
        + ''
          sed -i 's|/bin|${pkgs.coreutils}/bin|g' 90-wluma-backlight.rules
          install -Dm644 -t $out/lib/udev/rules.d/ 90-wluma-backlight.rules
        '';
    }
  );
in
{
  environment.systemPackages = [ wluma ];

  programs.light.enable = true;

  services.udev.packages = [ wluma ];
}
