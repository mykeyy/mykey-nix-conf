{ pkgs, ... }: {
  home.username = "mykey";
  home.homeDirectory = "/home/mykey";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  home.shellAliases = {
    fuckoff = "exit";
  };
}
