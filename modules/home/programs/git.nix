{
  flake.modules.homeManager.git = { pkgs, ... }: {
    programs.git = {
      enable = true;
      extraConfig.init.defaultBranch = "main";
    };

    home.packages = with pkgs; [
      gh
      glab
      lazygit
    ];
  };
}
