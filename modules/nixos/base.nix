{ config, inputs, ... }:
{
  flake.modules.nixos.base = { pkgs, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    hardware.enableAllFirmware = true;

    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = "backup";
      users.mykey.imports = [ config.flake.modules.homeManager.base ];
    };
  };
}
