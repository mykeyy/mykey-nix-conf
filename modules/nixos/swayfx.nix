{
  flake.modules.nixos.swayfx = { pkgs, ... }: {
    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
    };
  };
}
