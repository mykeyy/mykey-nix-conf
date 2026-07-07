{ config, inputs, ... }:
{
  configurations.tp490s.module = { pkgs, ... }: {
    imports = with config.flake.modules.nixos; [
      ./_hardware.nix
      base
      ly
      swayfx
      hardware-acceleration
      audio
      network
      printing
      packages
      zen-browser
    ];

    networking.hostName = "tp490s";
    time.timeZone = "Asia/Manila";
    i18n.defaultLocale = "en_PH.UTF-8";


    services.xserver.xkb.layout = "us";


    users.users.mykey = {
      isNormalUser = true;
      description = "mykey";
      shell = pkgs.nushell;
      extraGroups = [ "networkmanager" "wheel" ];
    };

    system.stateVersion = "25.11";
  };
}
