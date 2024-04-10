{ pkgs, ... }: {
  home.packages =
    let
      my-python-packages = ps: with ps; [
        numpy
        debugpy
        requests
      ];
    in
    [
      (pkgs.python3.withPackages my-python-packages)
    ];
}
