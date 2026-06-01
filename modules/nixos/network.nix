{
  flake.modules.nixos.network = {
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.powersave = false;

    environment.etc."NetworkManager/conf.d/10-wifi-metric.conf".text = ''
      [connection-wifi]
      match-device=type:wifi
      connection.route-metric=50
    '';

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        X11Forwarding = false;
      };
    };
    networking.firewall.allowedTCPPorts = [ 22 1714 1764 ];
    networking.firewall.allowedUDPPorts = [ 1714 1764 ];
    services.tailscale.enable = true;
  };
}
