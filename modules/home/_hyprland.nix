{ lib, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    plugins = [ pkgs.hyprlandPlugins.hy3 ];

    settings = {
      "$mod" = "SUPER";
      "$alt" = "ALT";

      monitor = ",preferred,auto,auto";

      general = {
        gaps_in = 12;
        gaps_out = 10;
        border_size = 3;
        layout = "hy3";
        resize_on_border = true;
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      plugin.hy3.tab_first_window = true;

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = false;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      exec-once = [
        "swaybg -i ${../../wallpapers/wallpaper.jpg} -m fill"
        "eww open bar"
        "systemctl --user restart xdg-desktop-portal-hyprland"
      ];

      bind = lib.concatLists [
        [
          "$mod SHIFT CTRL, Q, exit"

          "$mod, Return, exec, ghostty"
          "$mod SHIFT, E, exec, power-menu"
          "$mod, L, exec, swaylock"

          "$mod SHIFT, Q, hy3:killactive"

          "$mod, F, fullscreen, 1"
          "$mod SHIFT, F, fullscreen, 0"

          "$mod, TAB, hy3:togglefocuslayer"

          "$mod, S, hy3:makegroup, h"
          "$mod, V, hy3:makegroup, v"
          "$mod, T, hy3:makegroup, tab"

          "$mod, A, hy3:changefocus, raise"
          "$mod SHIFT, A, hy3:changefocus, lower"

          "$mod, E, hy3:expand, expand"
          "$mod SHIFT, E, hy3:expand, base"

          "$mod, R, hy3:changegroup, opposite"

          "$mod SHIFT, TAB, togglefloating"

          "$alt, Space, exec, ${pkgs.tofi}/bin/tofi-drun --drun-launch=true"
          "$alt, S, exec, screenshot"

          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.5"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ]

        (let
          hjkl = mod: lib.mapAttrsToList (k: d: "${mod}, ${k}, hy3:movefocus, ${d}") {
            h = "l";
            j = "d";
            k = "u";
            l = "r";
          };
          moveHjkl = mod: lib.mapAttrsToList (k: d: "${mod}, ${k}, hy3:movewindow, ${d}, once") {
            h = "l";
            j = "d";
            k = "u";
            l = "r";
          };
        in lib.concatLists [
          (hjkl "$mod")
          (hjkl "$mod CTRL")
          (moveHjkl "$mod SHIFT")
        ])

        (lib.concatLists (
          lib.genList (n: let ws = toString (n + 1); in [
            "$mod, ${ws}, workspace, ${ws}"
            "$mod SHIFT, ${ws}, hy3:movetoworkspace, ${ws}"
          ]) 9
        ))
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      windowrulev2 = [
        "float,class:^(pavucontrol)$"
        "float,class:^(wofi)$"
        "float,class:^(tofi)$"
      ];
    };
  };
}
