{ pkgs, config, inputs, ... }: let
  beansprout = pkgs.callPackage ../../tools/beansprout { beansproutSrc = inputs.beansprout-src; };
in {
  xdg.configFile = {
    "river/init" = {
      text = ''
        #!/bin/bash
        ${beansprout}/bin/beansprout &
        eww open bar
      '';
      executable = true;
    };

    "beansprout/config.kdl".text = ''
      attach_mode top
      primary_count 1
      primary_ratio 0.55
      single_window_ratio 1.0
      primary_side left
      focus_follows_pointer #true
      output_focus_follows_pointer #true
      pointer_warp_on_focus_change #true
      focus_on_send if_visible

      wallpaper_image_path "${config.home.homeDirectory}/.nix/wallpapers/wallpaper.jpg"

      borders {
        width 2
        color_focused "0xc4a7e7"
        color_unfocused "0x1f1d2e"
      }
      window_rules {
        float title="Picture-in-picture"
        float title="Picture-in-Picture"
        float title="*Preferences*"
        float app-id="pavucontrol"
        float app-id="tofi"
      }
      keybinds {
        spawn Mod4 Return ghostty
        spawn Mod4 Space "tofi-drun | xargs uwsm app --"
        spawn Mod1+Shift S screenshot
        spawn None Print screenshot
        spawn Mod1+Shift Print annotate
        spawn Mod1 V "cliphist list | tofi | cliphist decode | wl-copy"
        focus_next_window Mod4 J
        focus_prev_window Mod4 K
        focus_next_output Mod1 Period
        focus_prev_output Mod1 Comma
        send_to_next_output Mod4+Shift Period
        send_to_prev_output Mod4+Shift Comma
        zoom Mod4 Z
        toggle_float Mod1 F
        change_primary_ratio Mod4 H 0.05
        change_primary_ratio Mod4 L -0.05
        increment_primary_count Mod4 I
        decrement_primary_count Mod4 D
        reload_config Mod1 F1
        toggle_fullscreen Mod1 Return
        close_window Mod1 Q
        exit_river Mod1+Shift F4
        swap_next Mod4+Shift N
        swap_prev Mod4+Shift P
        move_left Mod4+Shift H 100
        move_down Mod4+Shift J 100
        move_up Mod4+Shift K 100
        move_right Mod4+Shift L 100
        resize_width Mod1 H -100
        resize_height Mod1 J 100
        resize_height Mod1 K -100
        resize_width Mod1 L 100

        spawn None XF86AudioRaiseVolume "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.5"
        spawn None XF86AudioLowerVolume "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        spawn None XF86AudioMute "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        spawn None XF86AudioPlay "playerctl play-pause"
        spawn None XF86AudioPrev "playerctl previous"
        spawn None XF86AudioNext "playerctl next"
        spawn None XF86MonBrightnessUp "brightnessctl set 5%+"
        spawn None XF86MonBrightnessDown "brightnessctl set 5%-"

        tag_bind Mod1 set_output_tags
        tag_bind Mod1+Shift set_window_tags
        tag_bind Mod1+Ctrl toggle_output_tags
        tag_bind Mod1+Ctrl+Shift toggle_window_tags
      }

      pointer_binds {
        move_window Mod4 BTN_LEFT
        resize_window Mod4 BTN_RIGHT
      }

      keyboard_layout {
        layout "us"
      }

      input {
        accel_profile "flat"
      }
    '';
  };
}
