{ pkgs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false;
    extraConfig = ''
      corner_radius 8
      blur enable
      blur_xray disable
      blur_passes 1
      shadows enable
      shadows_on_csd enable
      layer_effects "eww" blur enable; corner_radius 8
      workspace 1 output *
      workspace 2 output *
      workspace 3 output *
      workspace 4 output *
      workspace 5 output *
      exec swaybg -i ${../../wallpapers/wallpaper.jpg} -m fill
      exec eww open bar
      exec ${pkgs.wl-clipboard}/bin/wl-paste --type text --primary --watch ${pkgs.wl-clipboard}/bin/wl-copy
      exec systemctl --user import-environment WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP DBUS_SESSION_BUS_ADDRESS
      exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      exec systemctl --user restart xdg-desktop-portal-wlr
    '';
    config = {
      modifier = "Mod4";
      bars = [ ];
      terminal = "ghostty";
      menu = "${pkgs.tofi}/bin/tofi-drun | xargs -r swaymsg exec --";
      gaps = {
        inner = 12;
        outer = 10;
      };
      window = {
        border = 3;
        titlebar = false;
      };
      keybindings = {
        "Mod1+Return" = "fullscreen";
        "Mod1+q" = "kill";
        "Mod1+f1" = "reload";
        "Mod4+Shift+e" = "exec power-menu";
        "Mod4+Shift+q" = "kill";
        "Mod4+l" = "exec ${pkgs.swaylock-effects}/bin/swaylock --image ${../../wallpapers/wallpaper.jpg} --scaling fill --effect-blur 7x5 --effect-vignette 0.5:0.5 --clock --indicator --fade-in 0.2 --indicator-radius 100 --indicator-thickness 7 --ring-color 908caa --key-hl-color eb6f92 --inside-color 232136 --line-color 44415a --text-color e0def4 --separator-color 44415a -f";
        "Mod4+Return" = "exec ghostty";
        "Mod1+Space" = "exec ${pkgs.tofi}/bin/tofi-drun | xargs -r swaymsg exec --";
        "Mod4+p" = "exec wdisplays";
        "Print" = "exec screenshot";
        "Mod1+Print" = "exec annotate";
        "Mod1+v" = "exec cliphist list | ${pkgs.tofi}/bin/tofi | cliphist decode | wl-copy";
        "Mod1+s" = "exec screenshot";
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.5";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "Mod1+1" = "workspace number 1";
        "Mod1+2" = "workspace number 2";
        "Mod1+3" = "workspace number 3";
        "Mod1+4" = "workspace number 4";
        "Mod1+5" = "workspace number 5";
        "Mod1+Shift+1" = "move container to workspace number 1";
        "Mod1+Shift+2" = "move container to workspace number 2";
        "Mod1+Shift+3" = "move container to workspace number 3";
        "Mod1+Shift+4" = "move container to workspace number 4";
        "Mod1+Shift+5" = "move container to workspace number 5";
      };
    };
  };
}
