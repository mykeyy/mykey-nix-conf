{ pkgs, ... }: {

  programs.tofi = {
    enable = true;
    settings = {
      prompt-text = "> ";
      text-color = "#e0def4";
      prompt-color = "#ebbcba";
      selection-color = "#c4a7e7";
      background-color = "#191724e6";
      width = "100%";
      padding-left = "35%";
      padding-top = "25%";
      height = "100%";
      border-width = 0;
      outline-width = 0;
      result-spacing = 10;
      num-results = 14;
      font = "JetBrainsMono Nerd Font";
      font-size = 22;
    };
  };
}
