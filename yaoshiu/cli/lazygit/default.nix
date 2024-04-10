{ ... }: {
  programs.lazygit = {
    enable = true;
    settings = {
      theme = {
        lightTheme = false;
        activeBorderColor = [ "#a6da95" "bold" ];
        inactiveBorderColor = [ "#cad3f5" ];
        optionsTextColor = [ "#8aadf4" ];
        selectedLineBgColor = [ "#363a4f" ];
        selectedRangeBgColor = [ "#363a4f" ];
        cherryPickedCommitBgColor = [ "#8bd5ca" ];
        cherryPickedCommitFgColor = [ "#8aadf4" ];
        unstagedChangesColor = [ "red" ];
      };
      gui.language = "en";
      git = {
        merging.args = "--no-ff";
      };
      customCommands = [
        {
          key = "C";
          command = "git-cz c";
          description = "commit with commitizen";
          context = "files";
          loadingText = "opening commitizen commit tool";
          subprocess = true;
        }
      ];
    };
  };
}
