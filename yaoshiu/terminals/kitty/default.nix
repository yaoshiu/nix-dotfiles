{ ... }: {
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "Hasklug Nerd Font";
      font_features =
        builtins.concatStringsSep "\nfont_features "
          (map
            (x: "FiraCodeNFM-${x} +cv01 +cv02 +cv06 +ss01 +zero +ss04 +cv31 +cv29")
            [ "Bold" "Light" "Med" "Reg" "Ret" "SemBd" ]);
      font_size = 14;
      window_padding_width = 32;
      background_opacity = "0.8";
      background_blur = 64;
    };

    theme = "Catppuccin-Macchiato";
  };
}
