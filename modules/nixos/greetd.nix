{
  flake.modules.nixos.greetd = { pkgs, ... }: {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.writeShellScriptBin "regreet-session" ''
            export XDG_DATA_DIRS="/run/current-system/sw/share:''${XDG_DATA_DIRS}"
            exec ${pkgs.dbus}/bin/dbus-run-session -- ${pkgs.cage}/bin/cage -s -mlast -- ${pkgs.regreet}/bin/regreet
          ''}/bin/regreet-session";
          user = "greeter";
        };
      };
    };

    systemd.services.greetd = {
      after = [ "accounts-daemon.service" ];
      wants = [ "accounts-daemon.service" ];
    };

    programs.regreet.enable = true;
    stylix.targets.regreet.enable = false;
    environment.systemPackages = [ pkgs.cage ];
    services.accounts-daemon.enable = true;
  };
}
