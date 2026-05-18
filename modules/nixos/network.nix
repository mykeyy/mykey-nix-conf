{
  flake.modules.nixos.network = {
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.powersave = false;
    services.openssh.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];
    services.tailscale.enable = true;
  };
}
