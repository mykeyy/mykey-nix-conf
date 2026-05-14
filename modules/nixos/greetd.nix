{
  flake.modules.nixos.greetd = {
    services.greetd.enable = true;
    programs.regreet.enable = true;
  };
}
