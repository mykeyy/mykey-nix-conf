{
  flake.modules.nixos.plasma = { pkgs, ... }: {
    services.xserver.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sessionPackages = [ pkgs.kdePackages.plasma-workspace.sessions ];
    programs.kdeconnect.enable = true;
    environment.systemPackages = [ pkgs.kdePackages.kdeconnect-kde ];
    security.pam.services.greetd.kwallet.enable = true;
  };
}
