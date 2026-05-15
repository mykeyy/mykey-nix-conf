{
  flake.modules.nixos.greetd = { pkgs, ... }: {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "XDG_DATA_DIRS=/run/current-system/sw/share ${pkgs.cage}/bin/cage -s -mlast -- ${pkgs.regreet}/bin/regreet";
          user = "greeter";
        };
      };
    };
    programs.regreet.enable = true;
    environment.systemPackages = [ pkgs.cage ];
  };
}
