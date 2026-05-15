{
  flake.modules.nixos.swayfx = { pkgs, ... }: {
    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
    };

    services.libinput.enable = true;
  };
}
