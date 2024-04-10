{...}: {
  environment.homeBinInPath = true;
  environment.localBinInPath = true;

  boot.tmp.cleanOnBoot = true;
}
