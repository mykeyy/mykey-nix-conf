{ ... }: {
  programs.eww.enable = true;

  xdg.configFile = {
    "eww/eww.scss".source = ../../configs/eww/eww.scss;
    "eww/eww.yuck".source = ../../configs/eww/eww.yuck;
  };
}
