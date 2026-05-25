{ lib, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";

    settings = {
      "$mod" = "SUPER";
      "$alt" = "ALT";

      monitor = ",preferred,auto,auto";

      general = {
        gaps_in = 12;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding = 4;
        blur = {
          enabled = true;
          size = 2;
          passes = 1;
        };
        shadow = {
          enabled = false;
          range = 2;
          render_power = 2;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 4, myBezier"
          "windowsOut, 1, 4, default, popin 80%"
          "border, 1, 6, default"
          "fade, 1, 4, default"
          "workspaces, 1, 4, default"
        ];
      };

      render = {
        explicit_sync = 0;
        explicit_sync_kms = 0;
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
        "float,class:^(wofi)$"
        "float,class:^(tofi)$"
        "opacity 0.90,class:^(ghostty)$"
        "opacity 0.90 0.80,class:^(zen)$"
        "opacity 0.85 0.75,class:^(vesktop)$"
        "opacity 0.85 0.75,class:^(discord)$"
        "opacity 0.85 0.75,class:^(Spotify)$"
        "suppressevent maximize,class:.*"
      ];
    };
  };
}
