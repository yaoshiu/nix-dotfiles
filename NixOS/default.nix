{ pkgs, ... }: {
  imports = [
    ./desktop
    ./environment
    ./hardware
    ./nix
    ./secrets
    ./security
    ./users
  ];

  time.timeZone = "Asia/Shanghai";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "all" ];
  };

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

  environment.systemPackages = with pkgs; [
    killall
    bc
    unzipNLS
    wget
    yj
    nix-ld-rs
  ];

  programs.git.enable = true;

  programs.fish.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  networking.hostName = "NixOS";

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  services.openssh.enable = true;
}
