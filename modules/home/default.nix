{ config, ... }:
{
  flake.modules.homeManager.base = {
    imports = with config.flake.modules.homeManager; [
      terminal
      git
      editor
      nixcord
      browser
      gaming
      tools
    ];

    home.username = "mykey";
    home.homeDirectory = "/home/mykey";
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;
  };
}
