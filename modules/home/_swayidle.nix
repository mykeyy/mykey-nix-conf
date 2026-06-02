{ pkgs, ... }: let
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  swaymsg = "${pkgs.sway}/bin/swaymsg";
  lockArgs = "--image ${../../wallpapers/wallpaper.jpg} --scaling fill --effect-blur 7x5 --effect-vignette 0.5:0.5 --clock --indicator --fade-in 0.2 --indicator-radius 100 --indicator-thickness 7 --ring-color 908caa --key-hl-color eb6f92 --inside-color 232136 --line-color 44415a --text-color e0def4 --separator-color 44415a -f";
  lockCmd = "${swaylock} ${lockArgs}";
in {
  services.swayidle = {
    enable = true;
    systemdTargets = [ "sway-session.target" ];
    timeouts = [ { timeout = 300; command = lockCmd; } { timeout = 600; command = "${swaymsg} 'output * power off'"; resumeCommand = "${swaymsg} 'output * power on'"; } ];
    events = { "before-sleep" = lockCmd; "after-resume" = "${swaymsg} 'output * power on'"; lock = lockCmd; };
  };
}
