{
  flake.modules.homeManager.terminal = { pkgs, ... }: {
    programs.ghostty = {
      enable = true;
      settings = {
        font-size = 11;
        theme = "rose-pine";
      };
    };

    programs.nushell = {
      enable = true;
      extraConfig = ''
        $env.config.show_banner = false
      '';
    };

    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$all";
      };
    };

    programs.carapace.enable = true;
    programs.zoxide.enable = true;

    home.packages = with pkgs; [
      bat
      ripgrep
      fd
      btop
      fastfetch
    ];

    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
        truecolor = true;
      };
    };
  };
}
