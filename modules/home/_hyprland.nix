{ lib, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";

    settings = {
      "$mod" = "SUPER";
      "$alt" = "ALT";

      monitor = ",preferred,auto,auto";

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 0;
        layout = "dwindle";
        resize_on_border = false;
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.8;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
        };
        shadow = {
          enabled = false;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
          "been, 0.24, 0.9, 0.25, 0.91"
          "wind, 0.05, 0.9, 0.1, 1.05"
          "slow, 0, 0.85, 0.3, 1"
          "overshot, 0.7, 0.6, 0.1, 1.1"
          "bounce, 1.1, 1.6, 0.1, 0.85"
          "linear, 0, 0, 1, 1"
        ];
        animation = [
          "windowsIn, 1, 5, slow, popin"
          "windowsOut, 1, 7, been, popin 70%"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, linear"
          "fade, 1, 5, overshot"
          "workspaces, 1, 5, wind"
          "windows, 1, 5, bounce, popin"
        ];
      };



      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = false;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        vfr = true;
      };

      exec-once = [
        "swaybg -i ${../../wallpapers/wallpaper.jpg} -m fill"
        "eww open bar"
        "systemctl --user import-environment WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP DBUS_SESSION_BUS_ADDRESS"
        "systemctl --user restart xdg-desktop-portal-hyprland"
        "${pkgs.wl-clipboard}/bin/wl-paste --type text --primary --watch ${pkgs.wl-clipboard}/bin/wl-copy"
      ];

      bind = lib.concatLists [
        [
          "$mod SHIFT CTRL, Q, exit"

          "$mod, Return, exec, ghostty"
          "$mod SHIFT, E, exec, power-menu"
          "$mod, L, exec, swaylock"

          "$mod SHIFT, Q, killactive"

          "$mod, F, fullscreen, 1"
          "$mod SHIFT, F, fullscreen, 0"

          "$mod, J, togglesplit"

          "$mod SHIFT, TAB, togglefloating"

          "$mod, P, exec, wdisplays"
          "$alt, Space, exec, ${pkgs.tofi}/bin/tofi-drun --drun-launch=true"
          "$alt, S, exec, screenshot"
          ", Print, exec, screenshot"
          "$alt, Print, exec, annotate"
          "$alt, V, exec, cliphist list | ${pkgs.tofi}/bin/tofi | cliphist decode | wl-copy"

          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.5"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ]

        (let
          hjkl = mod: lib.mapAttrsToList (k: d: "${mod}, ${k}, movefocus, ${d}") {
            h = "l";
            j = "d";
            k = "u";
            l = "r";
          };
          moveHjkl = mod: lib.mapAttrsToList (k: d: "${mod}, ${k}, movewindow, ${d}") {
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
            "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
          ]) 9
        ))
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      windowrulev2 = [
        "float,class:^(pavucontrol)$"
        "size 50% 60%,class:^(pavucontrol)$"
        "float,class:^(wofi)$"
        "float,class:^(tofi)$"
        "opacity 0.90 0.90,class:^(ghostty)$"
        "opacity 0.90 0.70 1.0,class:^(zen)$"
        "opacity 0.85 0.70 1.0,class:^(discord)$"
        "opacity 0.80 0.60 1.0,class:^(Spotify)$"
        "suppressevent maximize,class:.*"
      ];
    };
  };
}
