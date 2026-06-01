{
  flake.modules.nixos.hyprland = { pkgs, ... }: {
    programs.hyprland.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      AQ_DRM_DEVICES = "/dev/dri/card0";
    };
  };
}
