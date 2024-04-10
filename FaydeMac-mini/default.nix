{ pkgs, lib, config, ... }: {
  imports = [
    ./users
    ./nix
  ];

  programs.fish = {
    enable = true;
    loginShellInit = let
      dquote = str: "\"" + str + "\"";

      makeBinPathList = map (path: path + "/bin");
    in ''
      fish_add_path --move --prepend --path ${lib.concatMapStringsSep " " dquote (makeBinPathList config.environment.profiles)}
      set fish_user_paths $fish_user_paths
    '';
  };

  homebrew = {
    enable = true;
    taps = [
      "daipeihust/tap"
    ];
    brews = [
      "im-select"
    ];
    casks = [
      "sanesidebuttons"
      "mos"
    ];
    masApps = {
      Bitwarden = 1352778147;
    };
    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };
  };

  environment = {
    interactiveShellInit = ''
      eval $(/opt/homebrew/bin/brew shellenv)
      
      if [[ $(basename $(ps -p $(ps -p $$ -o ppid=) -o comm=)) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        if [[ -o login ]]
        then
          LOGIN_OPTION='--login'
        else
          LOGIN_OPTION=
        fi
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';

    systemPackages = with pkgs; [
      clang
      git
      uutils-coreutils-noprefix
      wget
    ];
  };
}
