{
  flake.modules.nixos.greetd = { pkgs, ... }: {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.writeShellScriptBin "regreet-session" ''
            export XDG_DATA_DIRS="/run/current-system/sw/share:''${XDG_DATA_DIRS}"
            exec ${pkgs.cage}/bin/cage -s -mlast -- ${pkgs.regreet}/bin/regreet
          ''}/bin/regreet-session";
          user = "greeter";
        };
      };
    };
    programs.regreet.enable = true;
    environment.systemPackages = [ pkgs.cage ];
  };
}
