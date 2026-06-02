{
  flake.modules.nixos.hardware-acceleration = { pkgs, ... }: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        vpl-gpu-rt
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };

    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      LIBVA_DRIVER_NAME = "iHD";
      VDPAU_DRIVER = "va_gl";
    };
  };
}
