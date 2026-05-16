{ ... }: {
  programs.eww.enable = true;

  xdg.configFile = {
    "eww/eww.scss".source = ../../configs/eww/eww.scss;
    "eww/eww.yuck".source = ../../configs/eww/eww.yuck;
    "kanshi/config".source = ../../configs/kanshi;
    "scripts/power-cycle.sh" = {
      source = ../../configs/scripts/power-cycle.sh;
      executable = true;
    };
  };
}
