{ ... }:

{
  programs.fzf = {
    enable = true;

    colors = {
      "bg+" = "#363a4f";
      bg = "#24273a";
      spinner = "#f4dbd6";
      hl = "#ed8796";
      fg = "#cad3f5";
      header = "#ed8796";
      info = "#c6a0f6";
      pointer = "#f4dbd6";
      marker = "#f4dbd6";
      "fg+" = "#cad3f5";
      prompt = "#c6a0f6";
      "hl+" = "#ed8796";
    };

    defaultOptions = [
      "--preview"
      "'bat --color=always --style=numbers --line-range=:500 {}'"
    ];
  };
}
