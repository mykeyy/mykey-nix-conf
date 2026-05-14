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
        font-size = 14;
        theme = "rose-pine";
        background-opacity = 0.95;
      };
    };

    programs.nushell = {
      enable = true;
      settings = {
        show_banner = false;
        buffer_editor = "hx";
      };
      extraEnv = ''
        $env.EDITOR = "hx"
        $env.VISUAL = "hx"
        $env.NH_FLAKE = $"($env.HOME)/.nix"
      '';
      extraConfig = ''
        fastfetch
      '';
    };

    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$all";
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };

    programs.fastfetch = {
      enable = true;
      settings = {
        logo.source = ../../configs/fastfetch-logo.png;
        display.separator = " ";
        modules = [
          { type = "custom"; format = "╭─────────────────────────────────────────────────────╮"; }
          { type = "os"; key = "  OS:"; keyColor = "red"; }
          { type = "kernel"; key = "  Kernel:"; keyColor = "red"; }
          { type = "command"; key = "  OS Age:"; keyColor = "31"; text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days"; }
          { type = "uptime"; key = "  Uptime:"; keyColor = "red"; }
          { type = "packages"; key = "  Packages:"; keyColor = "green"; }
          { type = "wm"; key = "  WM:"; keyColor = "yellow"; }
          { type = "shell"; key = "  Shell:"; keyColor = "yellow"; }
          { type = "terminal"; key = "  Terminal:"; keyColor = "yellow"; }
          { type = "localip"; key = "  Local IP:"; keyColor = "yellow"; }
          { type = "custom"; format = "╰─────────────────────────────────────────────────────╯"; }
          "break"
          { type = "custom"; format = "╭─────────────────────────────────────────────────────╮"; }
          { type = "cpu"; format = "{1}"; key = "  CPU:"; keyColor = "blue"; }
          { type = "gpu"; format = "{2}"; key = "  GPU:"; keyColor = "blue"; }
          { type = "memory"; key = "  Memory:"; keyColor = "magenta"; }
          { type = "disk"; key = "  Disk:"; keyColor = "green"; }
          { type = "custom"; format = "╰─────────────────────────────────────────────────────╯"; }
        ];
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
          ClearURLs.enable = true;
          spotifyControls.enable = true;
          viewRaw.enable = true;
        };
      };
    };

    xdg.configFile = {
      "kglobalshortcutsrc".source = ../../configs/kglobalshortcutsrc;
      "kwinrc".source = ../../configs/kwinrc;
      "plasmashellrc".source = ../../configs/plasmashellrc;
      "plasmarc".source = ../../configs/plasmarc;
      "plasma-localerc".source = ../../configs/plasma-localerc;
      "plasma-org.kde.plasma.desktop-appletsrc".source = ../../configs/plasma-org.kde.plasma.desktop-appletsrc;
      "ghostty/themes/rose-pine".source = ../../configs/ghostty-rose-pine;
    };

    home.packages = with pkgs; [
      bat
      ripgrep
      fd
      btop
      gh
      glab
      lazygit
      prismlauncher
      nh
      yazi
      obs-studio
      killall
      unzip
      wget
      tofi
      swaybg
      swaylock
      hyprshot
      spotify
      spicetify-cli
      nerd-fonts.jetbrains-mono
      eww
    ];

    wayland.windowManager.sway = {
      enable = true;
      extraConfig = ''
        workspace 1 output *
        workspace 2 output *
        workspace 3 output *
        workspace 4 output *
        workspace 5 output *
      '';
      config = {
        modifier = "Mod4";
        terminal = "ghostty";
        menu = "${pkgs.tofi}/bin/tofi-drun --drun-launch=true";
        output."*".bg = "${../../wallpapers/wallpaper.jpg} fill";
        gaps = {
          inner = 10;
          outer = 10;
        };
        window = {
          border = 3;
          titlebar = false;
        };
        startup = [
          { command = "systemctl --user restart xdg-desktop-portal-wlr"; }
        ];
        keybindings = {
          "Mod1+Return" = "fullscreen";
          "Mod1+q" = "kill";
          "Mod1+f1" = "reload";
          "Mod4+Return" = "exec ghostty";
          "Mod1+Space" = "exec ${pkgs.tofi}/bin/tofi-drun --drun-launch=true";
          "Mod1+s" = "exec ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only";
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.5";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "Mod1+1" = "workspace number 1";
          "Mod1+2" = "workspace number 2";
          "Mod1+3" = "workspace number 3";
          "Mod1+4" = "workspace number 4";
          "Mod1+5" = "workspace number 5";
          "Mod1+Shift+1" = "move container to workspace number 1";
          "Mod1+Shift+2" = "move container to workspace number 2";
          "Mod1+Shift+3" = "move container to workspace number 3";
          "Mod1+Shift+4" = "move container to workspace number 4";
          "Mod1+Shift+5" = "move container to workspace number 5";
        };
      };
    };
  };
}
