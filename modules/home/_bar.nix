{ pkgs, lib, config, ... }: {
  programs.eww.enable = true;

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 4;
        modules-left = [ "custom/logo" "hyprland/workspaces" ];
        modules-center = [ "mpris" ];
        modules-right = [ "wireplumber" "memory" "battery" "clock" ];

        "custom/logo" = {
          format = "󱄅";
          tooltip = false;
        };

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          all-outputs = true;
        };

        "mpris" = {
          format = "  {artist} - {title}";
          format-paused = "  {artist} - {title} (Paused)";
          max-length = 50;
        };

        "wireplumber" = {
          format = "{icon}  {volume}%";
          format-muted = "   Muted";
          format-icons = [ " " " " ];
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        "memory" = {
          format = "   {percentage}%";
          interval = 5;
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}   {capacity}%";
          format-charging = "   {capacity}%";
          format-plugged = "   {capacity}%";
          format-alt = "{icon}  {time}";
          format-icons = [ "" "" "" "" "" ];
        };

        "clock" = {
          format = "   {:%I:%M %p}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", sans-serif;
        font-size: 13px;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background-color: #191724;
        color: #e0def4;
        transition-property: background-color;
        transition-duration: .5s;
        border-bottom: 2px solid #2a273f;
      }

      #workspaces button {
        padding: 0 10px;
        color: #e0def4;
        background-color: transparent;
      }

      #workspaces button:hover {
        color: #ebbcba;
        background-color: #2a273f;
      }

      #workspaces button.active {
        color: #eb6f92;
        font-weight: bold;
      }

      #workspaces button.focused {
        color: #eb6f92;
        font-weight: bold;
      }

      #custom-logo {
        font-size: 16px;
        color: #9ccfd8;
        padding-left: 15px;
        padding-right: 15px;
      }

      #mpris {
        color: #e0def4;
        padding: 0 15px;
      }

      #wireplumber, #memory, #battery, #clock {
        padding: 0 15px;
        margin: 4px 0;
      }

      #wireplumber {
        color: #c4a7e7;
      }

      #memory {
        color: #9ccfd8;
      }

      #battery {
        color: #ffd5cd;
      }

      #battery.charging {
        color: #e0def4;
      }

      #battery.warning {
        color: #f6c177;
      }

      #battery.critical:not(.charging) {
        color: #eb6f92;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #clock {
        color: #e0def4;
        font-weight: bold;
        padding-right: 20px;
      }

      @keyframes blink {
        to {
          background-color: transparent;
          color: #191724;
        }
      }
    '';
  };

  xdg.configFile = {
    # CSS stays inline — no separate .scss file needed
    "eww/eww.scss".text = ''
      * { all: unset; }
      .bar { background-color: #191724; color: #e0def4; padding: 10px; }
      .sidestuff slider { all: unset; color: #ffd5cd; }
      .metric scale trough highlight { all: unset; background-color: #ebbcba; color: #000000; border-radius: 10px; }
      .metric scale trough { all: unset; background-color: #2a273f; border-radius: 50px; min-height: 3px; min-width: 50px; margin-left: 10px; margin-right: 20px; }
      .nix-logo { font-family: "JetBrainsMono Nerd Font"; font-size: 14px; color: #9ccfd8; padding-right: 6px; }
      .workspaces button { font-family: "JetBrainsMono Nerd Font"; font-size: 12px; padding: 0 8px; }
      .workspaces button:hover { color: #D35D6E; }
      .workspaces button.active { color: #eb6f92; font-weight: bold; }
      .music { font-family: "JetBrainsMono Nerd Font"; font-size: 12px; }
      .label { font-family: "JetBrainsMono Nerd Font"; font-size: 12px; padding-right: 8px; }
      .time { font-family: "JetBrainsMono Nerd Font"; font-size: 12px; color: #e0def4; padding: 0 8px; }
      .label.battery-critical { color: #eb6f92; }
      .label.battery-low { color: #f6c177; }
      .label.battery-good { color: #9ccfd8; }
      .label.battery-charging { color: #e0def4; }
      .label.battery-full { color: #e0def4; }
    '';

    # Yuck kept as source file to avoid Nix string escaping issues
    "eww/eww.yuck".source = ../../configs/eww/eww.yuck;
    "kanshi/config".source = ../../configs/kanshi;
  };
}
