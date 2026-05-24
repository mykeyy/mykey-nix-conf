{ ... }:
{
  flake.modules.nixos.network = { pkgs, lib, ... }: {
    networking.useNetworkd = true;
    networking.wireless.enable = true;
    networking.wireless.userControlled = true;
    networking.wireless.extraConfig = ''
      update_config=1
    '';

    systemd.services.wpa_supplicant.serviceConfig.ExecStart = lib.mkForce [
      ""
      "${pkgs.wpa_supplicant}/bin/wpa_supplicant -i wlp0s20f3 -c /etc/wpa_supplicant/wpa_supplicant.conf -Dnl80211,wext -s -u"
    ];

    systemd.tmpfiles.rules = [
      "d /etc/wpa_supplicant 0755 wpa_supplicant wpa_supplicant -"
    ];

    powerManagement.resumeCommands = ''
      systemctl restart wpa_supplicant
    '';

    services.openssh.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 1714 1764 ];
    networking.firewall.allowedUDPPorts = [ 1714 1764 ];
    services.tailscale.enable = true;
  };
}
