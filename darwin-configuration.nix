{ pkgs, ... }:
let
  # proxy = "http://192.168.110.77:7890";
  proxy = "";
  proxy_env = {
    no_proxy = "127.0.0.1,localhost,*.phieash.moe";
    http_proxy = proxy;
    https_proxy = proxy;
    rsync_proxy = proxy;
    ftp_proxy = proxy;
    all_proxy = proxy;
  };
in
{
  environment.variables = proxy_env;
  launchd.daemons."nix-daemon".environment = proxy_env;
  services.nix-daemon.enable = true;
  nix = {
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];
    };
    package = pkgs.nix;
  };
  nixpkgs.hostPlatform = "aarch64-darwin";

  programs.zsh.enable = true;

  programs.bash.enable = true;
}
