{ ... }:
{
  programs.ssh = {
    hostKeyAlgorithms = [ "ssh-rsa" ];
    pubkeyAcceptedKeyTypes = [ "ssh-rsa" ];
  };
}
