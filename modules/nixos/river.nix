{
  flake.modules.nixos.river = { pkgs, inputs, ... }: {
    environment.systemPackages = with pkgs; [
      river
      (pkgs.callPackage ../../tools/beansprout { beansproutSrc = inputs.beansprout-src; })
    ];

    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "river";
    };
  };
}
