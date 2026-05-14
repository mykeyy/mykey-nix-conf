{
  flake.modules.homeManager.tools = { pkgs, ... }: {
    home.packages = with pkgs; [
      nh
      yazi
      obs-studio
      killall
      unzip
      wget
    ];
  };
}
