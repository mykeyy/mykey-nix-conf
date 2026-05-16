{ pkgs, lib, ... }: {
  systemd.user.services.hyprpaper = lib.mkForce {
    Unit = {
      Description = "hyprpaper (disabled)";
      ConditionPathExists = "/nonexistent";
    };
    Service = {
      ExecStart = "${pkgs.coreutils}/bin/true";
    };
  };
}
