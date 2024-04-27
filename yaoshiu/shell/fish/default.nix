{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    functions = {
      fish_greeting = ''
        # Sleep for a short time to avoid the greeting message being printed before the shell prompt
        sleep 0.2

        # Randomly select a greeting using random choice
        set greeting (random choice "Hello" "Hola" "Bonjour" "Guten Tag" "Ciao" "こんにちは" "안녕하세요" "Привет" "Olá" "Merhaba" "你好")

        # Define ANSI color codes for foreground colors
        set color (random choice 31 32 33 34 35 36 37) # These codes correspond to red, green, yellow, blue, magenta, cyan, and white


        # Get terminal width
        set term_width (tput cols)

        # Create greeting message
        set greeting_message (printf "\e[%sm%s, %s!\e[0m" $color $greeting $USER)

        # Calculate padding for center alignment
        set message_length (string length $greeting_message)
        set padding (math "round(($term_width - $message_length) / 2)")

        # Check if padding is less than 0 and adjust if necessary
        if test $padding -lt 0
            set padding 0
        end

        # Print the greeting message with padding for center alignment
        printf '%*s%s\n' $padding ''' $greeting_message
      '';
    };

    interactiveShellInit = ''
      # Vi key bindings
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_visual block
      set fish_vi_force_cursor
      fish_vi_key_bindings

      # Theme
      fish_config theme choose "Catppuccin Macchiato"
    '';
  };

  xdg.configFile."fish/themes/Catppuccin Macchiato.theme".source = "${
    pkgs.fetchFromGitHub {
      name = "fish";
      owner = "catppuccin";
      repo = "fish";
      rev = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
      hash = "sha256-Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg=";
    }
  }/themes/Catppuccin Macchiato.theme";
}
