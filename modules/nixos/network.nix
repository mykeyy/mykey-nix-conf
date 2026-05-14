{
  flake.modules.nixos.network = {
    networking.networkmanager.enable = true;
    services.openssh.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];
    services.tailscale.enable = true;
  };
}
