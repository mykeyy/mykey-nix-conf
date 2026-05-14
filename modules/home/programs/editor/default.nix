{
  flake.modules.homeManager.editor = { pkgs, ... }: {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
    };

    programs.helix = {
      enable = true;
      settings = {
        theme = "rose_pine";
        editor = {
          line-number = "relative";
          bufferline = "always";
        };
      };
    };
  };
}
