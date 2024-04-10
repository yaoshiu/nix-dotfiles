{pkgs, ...}: {
  gtk = {
    enable = true;
    theme = {
      name = "WhiteSur-Light";
      package = pkgs.whitesur-gtk-theme;
    };

    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };
  };
}
