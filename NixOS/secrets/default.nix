{ ... }: {
  sops = {
    defaultSopsFile = ./default.yaml;
    age = {
      sshKeyPaths = [
        "/home/yaoshiu/.ssh/id_ed25519"
        "/root/.ssh/id_ed25519"
      ];
    };
    secrets."password/yaoshiu@NixOS" = {};
  };
}
