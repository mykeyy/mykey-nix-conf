{ config, inputs, ... }:
{
  flake.modules.nixos.base = { pkgs, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      max-jobs = 4;
      min-free = 1024 * 1024 * 1024;
      max-free = 3 * 1024 * 1024 * 1024;
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    hardware.enableAllFirmware = true;
    hardware.bluetooth.enable = true;
    services.libinput.enable = true;
    security.pam.services.swaylock = {};

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        dejavu_fonts
        nerd-fonts.jetbrains-mono
        (pkgs.stdenv.mkDerivation {
          pname = "apple-color-emoji";
          version = "26";
          src = pkgs.fetchurl {
            url = "https://github.com/samuelngs/apple-emoji-ttf/releases/download/macos-26-20260219-2aa12422/AppleColorEmoji-Linux.ttf";
            sha256 = "sha256-U1oEOvBHBtJEcQWeZHRb/IDWYXraLuo0NdxWINwPUxg=";
          };
          dontUnpack = true;
          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            cp $src $out/share/fonts/truetype/AppleColorEmoji.ttf
          '';
        })
      ];
      fontconfig.defaultFonts = {
        serif = [ "DejaVu Serif" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        emoji = [ "Apple Color Emoji" ];
      };
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs = { inherit inputs; };
      users.mykey.imports = [ config.flake.modules.homeManager.base ];
    };
  };
}
