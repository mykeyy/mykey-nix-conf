{ config, inputs, ... }:
{
  configurations.tp490s.module = { pkgs, ... }: {
    imports = with config.flake.modules.nixos; [
      ./_hardware.nix
      base
      greetd
      plasma
      swayfx
      hyprland
      hardware-acceleration
      audio
      network
      printing
      packages
      stylix
      zen-browser
    ];

    networking.hostName = "tp490s";
    time.timeZone = "Asia/Manila";
    i18n.defaultLocale = "en_PH.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fil_PH";
      LC_IDENTIFICATION = "fil_PH";
      LC_MEASUREMENT = "fil_PH";
      LC_MONETARY = "fil_PH";
      LC_NAME = "fil_PH";
      LC_NUMERIC = "fil_PH";
      LC_PAPER = "fil_PH";
      LC_TELEPHONE = "fil_PH";
      LC_TIME = "fil_PH";
    };

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
