{ pkgs, ... }: {
  home.packages = with pkgs; [
    clojure
    leiningen
  ];
}
