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
  home.packages = [ wluma ];

  xdg.configFile."wluma/config.toml" = {
    text = ''
      [als.webcam]
      video = 0
      thresholds = { 0 = "night", 15 = "dark", 30 = "dim", 45 = "normal", 60 = "bright", 75 = "outdoors" }

      [[output.backlight]]
      name = "eDP-1"
      path = "/sys/class/backlight/nvidia_0"
      capturer = "wlroots"
    '';
  };
}
