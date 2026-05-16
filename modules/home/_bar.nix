{ pkgs, ... }: {
  programs.eww.enable = true;

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
      .power-profile { font-weight: bold; padding: 0 8px; }
      .pp-performance { color: #eb6f92; }
      .pp-balanced { color: #e0def4; }
      .pp-power-saver { color: #f6c177; }
    '';

    # Yuck kept as source file to avoid Nix string escaping issues
    "eww/eww.yuck".source = ../../configs/eww/eww.yuck;
    "kanshi/config".source = ../../configs/kanshi;
  };
}
