{
  flake.modules.nixos.hyprland = { pkgs, ... }: {
    programs.hyprland = {
      enable = true;
      withUWSM = false;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    services.libinput.enable = true;
  };
}
