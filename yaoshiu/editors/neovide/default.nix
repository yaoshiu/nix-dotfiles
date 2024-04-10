{ pkgs, ... }: {
  home = {
    packages = [ pkgs.neovide ];
    shellAliases = {
      nv = "neovide";
    };
  };

  xdg.configFile."neovide/config.toml".source = (pkgs.formats.toml { }).generate "neovide-config.toml" {
    maximized = false;

    font = {
      normal = [ "Hasklug Nerd Font Mono" ];
      size = 18;
    };
  };

  wayland.windowManager.hyprland.settings.windowrule = [
    "suppressevent maximize, ^(neovide)$"
    "noanim, ^(neovide)$"
  ];

  programs.nixvim.globals = {
    neovide_transparency = 0.75;
    neovide_unlink_border_highlights = true;
    neovide_window_blurred = true;
  };
}
