{ ... }: {
  programs.bat.enable = true;
  programs.ripgrep.enable = true;
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      truecolor = true;
    };
  };
  programs.git = {
    enable = true;
    settings.init.defaultBranch = "main";
  };
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        line-number = "relative";
        bufferline = "always";
      };
    };
  };
  programs.vscodium.enable = true;
}
