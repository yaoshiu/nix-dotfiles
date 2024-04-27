{ ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "Hasklug Nerd Font Mono";
      font_size = 14;
      window_padding_width = 32;
      background_opacity = "0.8";
      background_blur = 64;
      macos_option_as_alt = true;
    };

    theme = "Catppuccin-Macchiato";
  };
}
