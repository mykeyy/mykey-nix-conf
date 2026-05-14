{
  flake.modules.nixos.greetd = { pkgs, ... }: {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.cage}/bin/cage -s -mlast -- ${pkgs.regreet}/bin/regreet";
          user = "greeter";
        };
      };
    };
    programs.regreet.enable = true;
    environment.systemPackages = [ pkgs.cage ];
  };
}
