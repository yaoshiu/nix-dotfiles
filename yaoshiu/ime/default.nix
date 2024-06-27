{ pkgs, ... }:
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      libsForQt5.fcitx5-qt
      fcitx5-gtk
      fcitx5-configtool
    ];
  };

  xdg.dataFile.fcitx5 =
    let
      xmjd6-rere = pkgs.stdenv.mkDerivation {
        name = "xmjd-rere";
        src = pkgs.fetchFromGitHub {
          owner = "hugh7007";
          repo = "xmjd6-rere";
          rev = "master";
          hash = "sha256-DEBsy3+dGdkIAN36dCrZbFKO+W6hqZCi8VFC2x37BM0=";
        };

        buildPhase = ''
          mkdir -p $out/share/fcitx5
          cp -r . $out/share/fcitx5/rime
        '';
      };
    in
    {
      source = "${xmjd6-rere}/share/fcitx5";
      recursive = true;
    };
}
