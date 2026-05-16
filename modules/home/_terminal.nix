{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "rose-pine";
      background-opacity = 0.95;
      font-size = 14;
      command = "${pkgs.nushell}/bin/nu";
    };
  };
}
