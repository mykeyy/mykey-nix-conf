{ ... }: {
  stylix.targets.mako.enable = false;

  services.mako = {
    enable = true;
    settings = {
      background-color = "#191724CC";
      text-color = "#e0def4";
      border-color = "#c4a7e7";
      border-size = 2;
      border-radius = 8;
      font = "JetBrainsMono Nerd Font 12";
      default-timeout = 5000;
      anchor = "top-right";
      margin = "12,12";
      padding = "8,12";
    };
  };
}
