{
  flake.modules.nixos.power = {
    services.power-profiles-daemon.enable = true;
  };
}
