{
  flake.modules.nixos.hyprland = { pkgs, ... }: {
    programs.hyprland = {
      enable = true;
      withUWSM = false;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      AQ_DRM_DEVICES = "/dev/dri/card0";
    };
    services.libinput.enable = true;
  };
}
