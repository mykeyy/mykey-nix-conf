{ pkgs, ... }: {
  programs.eww.enable = true;

  xdg.configFile = {
    "eww/eww.scss".text = ''
      * {
        all: unset;
      }

      .bar0 {
        background-color: #191724;
        color: #e0def4;
        padding: 10px;
      }

      .sidestuff slider {
        all: unset;
        color: #ffd5cd;
      }

      .metric scale trough highlight {
        all: unset;
        background-color: #ebbcba;
        color: #000000;
        border-radius: 10px;
      }

      .metric scale trough {
        all: unset;
        background-color: #2a273f;
        border-radius: 50px;
        min-height: 3px;
        min-width: 50px;
        margin-left: 10px;
        margin-right: 20px;
      }

      .label-ram {
        font-size: large;
      }

      .workspaces button:hover {
        color: #D35D6E;
      }

      .nix-logo {
        font-size: 18px;
        padding-right: 10px;
      }

      .active {
        color: #c4a7e7;
        font-weight: bold;
      }

      .music {
        color: #f6c177;
      }

      .time {
        color: #e0def4;
        font-weight: bold;
      }

      .battery-good { color: #9ccfd8; }
      .battery-charging { color: #f6c177; }
      .battery-low { color: #eb6f92; }
      .battery-critical { color: #eb6f92; }
      .battery-full { color: #9ccfd8; }
    '';

    "eww/eww.yuck".text = ''
      (defwidget bar0 []
        (centerbox :orientation "h"
          (workspaces)
          (music)
          (sidestuff)))

      (defwidget sidestuff []
        (box :class "sidestuff" :orientation "h" :space-evenly false :halign "end"
          (metric :label "''${(volume == 0) ? "X " : (volume < 75) ? "o  " : "o  "} ''${volume}%"
                  :value volume
                  :onchange "wpctl set-volume @DEFAULT_AUDIO_SINK@ {}%")
          (metric :label "''${round(EWW_RAM.used_mem_perc, 0)}%"
                  :value {EWW_RAM.used_mem_perc}
                  :onchange "")
          (box :class "label ''${battery_state}" "''${battery_icon}  ''${battery_pct}%")
          (box :class "time" time)))

      (defwidget workspaces []
        (box :class "workspaces"
             :orientation "h"
             :space-evenly true
             :halign "start"
             :spacing 10
          (box :class "nix-logo" "NT ")
          (button :onclick "swaymsg workspace number 1" :class {active_ws == "1" ? "active" : ""} 1)
          (button :onclick "swaymsg workspace number 2" :class {active_ws == "2" ? "active" : ""} 2)
          (button :onclick "swaymsg workspace number 3" :class {active_ws == "3" ? "active" : ""} 3)
          (button :onclick "swaymsg workspace number 4" :class {active_ws == "4" ? "active" : ""} 4)
          (button :onclick "swaymsg workspace number 5" :class {active_ws == "5" ? "active" : ""} 5)))

      (defwidget music []
        (box :class "music"
             :orientation "h"
             :space-evenly false
             :halign "center"
          {music != "" ? "''${music}" : ""}))

      (defwidget metric [label value onchange]
        (box :orientation "h"
             :class "metric"
             :space-evenly false
          (box :class "label" label)
          (scale :min 0
                 :max 101
                 :active {onchange != ""}
                 :value value
                 :onchange onchange)))

      (defpoll battery_pct :interval "10s"
        :initial "100"
        "now=$(cat /sys/class/power_supply/BAT0/energy_now 2>/dev/null || echo 1); full=$(cat /sys/class/power_supply/BAT0/energy_full 2>/dev/null || echo 1); pct=$(awk \"BEGIN {printf \\\"%.2f\\\", ($now/$full)*100}\"); if echo \"$pct\" | grep -q '\\.00$'; then echo \"$pct\" | cut -d. -f1; else echo \"$pct\"; fi")

      (defpoll battery_icon :interval "10s"
        :initial "battery-full"
        "bat=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 100); sta=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo Unknown); if [ \"$sta\" = 'Charging' ]; then echo 'T'; elif [ $bat -le 20 ]; then echo '!'; elif [ $bat -le 40 ]; then echo '!!'; elif [ $bat -le 60 ]; then echo '!!!'; elif [ $bat -le 80 ]; then echo '!!!!'; else echo '!!!!!'; fi")

      (defpoll battery_state :interval "10s"
        :initial "battery-good"
        "bat=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 100); sta=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo Unknown); if [ \"$sta\" = 'Charging' ]; then if [ $bat -eq 100 ]; then echo 'battery-full'; else echo 'battery-charging'; fi; elif [ $bat -le 20 ]; then echo 'battery-critical'; elif [ $bat -le 50 ]; then echo 'battery-low'; else echo 'battery-good'; fi")

      (deflisten music :initial ""
        "${pkgs.playerctl}/bin/playerctl --follow metadata --format '{{ artist }} - {{ title }}' || true")

      (defpoll volume
        :interval "10ms"
        "${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ print int($2 * 100) }'")

      (defpoll time :interval "10ms"
        "date '+%H:%M'")

      (deflisten active_ws :initial "1"
        "swaymsg -m -t subscribe '[\"workspace\"]' | jq --unbuffered -r '.current.name // empty'")

      (defwindow bar0
        :monitor 0
        :windowtype "dock"
        :stacking "fg"
        :exclusive true
        :focusable false
        :geometry (geometry :x "0%"
                            :y "0%"
                            :width "100%"
                            :height "20px"
                            :anchor "top center")
        (bar0))
    '';
  };
}
