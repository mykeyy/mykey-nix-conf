{ config, inputs, rootPath, ... }:
{
  flake.modules.homeManager.base = { pkgs, ... }: {
    imports = [ inputs.nixcord.homeModules.nixcord ];

    home.username = "mykey";
    home.homeDirectory = "/home/mykey";
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;

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
      extraConfig.init.defaultBranch = "main";
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

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
    };

    programs.nixcord = {
      enable = true;
      vesktop.enable = true;
      quickCss = builtins.readFile (rootPath + "/quickcss.nix");
      config = {
        useQuickCss = true;
        frameless = true;
        plugins = {
          alwaysAnimate.enable = true;
          betterSettings.enable = true;
          biggerStreamPreview.enable = true;
          clearURLs.enable = true;
          imageZoom.enable = true;
          noBlockedMessages.enable = true;
          noF1.enable = true;
          noProfileThemes.enable = true;
          noRTC.enable = true;
          noSystemBadge.enable = true;
          noTrack.enable = true;
          plainFolderIcon.enable = true;
          readAllNotificationsButton.enable = true;
          relationshipNotifier.enable = true;
          spotifyControls.enable = true;
          textReplace.enable = true;
          translate.enable = true;
          typingIndicator.enable = true;
          viewRaw.enable = true;
        };
      };
    };

    xdg.configFile = {
      "kglobalshortcutsrc".source = ../../configs/kglobalshortcutsrc;
      "kwinrc".source = ../../configs/kwinrc;
      "kwinrulesrc".source = ../../configs/kwinrulesrc;
    };

    home.packages = with pkgs; [
      bat
      ripgrep
      fd
      btop
      fastfetch
      gh
      glab
      lazygit
      zen-browser
      prismlauncher
      nh
      yazi
      obs-studio
      killall
      unzip
      wget
    ];
  };
}
