{ pkgs, ... }: {
  services.cliphist.enable = true;

  systemd.user.services.wl-clipboard-sync = {
    Unit = {
      Description = "Sync Wayland clipboard and primary selection";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --primary --watch ${pkgs.wl-clipboard}/bin/wl-copy";
      Restart = "always";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
