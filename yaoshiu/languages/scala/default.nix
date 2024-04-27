{ pkgs, ... }:
{
  home.packages = [
    pkgs.scala
    pkgs.sbt-with-scala-native
    pkgs.coursier
    pkgs.mill
  ];
}
