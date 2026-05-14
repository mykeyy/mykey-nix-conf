{
  flake.modules.nixos.plasma = {
    services.xserver.enable = true;
    services.desktopManager.plasma6.enable = true;
  };
}
