{ ... }:
{
  imports = [ ./my-module.nix ];

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      config.font = wezterm.font("Hasklug Nerd Font")
      config.font_size = 14.0

      config.color_scheme = "Catppuccin Macchiato"
      config.window_background_opacity = 0.75
      config.text_background_opacity = 0.75
      config.macos_window_background_blur = 64

      config.window_padding = {
        left = "32pt",
        right = "32pt",
        top = "32pt",
        bottom = "32pt",
      }

      config.keys = {
        -- CTRL-SHIFT-l activates the debug overlay
        { key = 'L', mods = 'CTRL', action = wezterm.action.ShowDebugOverlay },
      }

      local act = wezterm.action

      config.mouse_bindings = {
        {
          event = { Down = { streak = 1, button = { WheelUp = 1 } } },
          mods = 'NONE',
          action = act.ScrollByLine(-3),
          alt_screen = false,
        },
        {
          event = { Down = { streak = 1, button = { WheelDown = 1 } } },
          mods = 'NONE',
          action = act.ScrollByLine(3),
          alt_screen = false,
        },
      }

      config.use_fancy_tab_bar = false
      config.tab_bar_at_bottom = true

      config.native_macos_fullscreen_mode = true
    '';
  };
}
