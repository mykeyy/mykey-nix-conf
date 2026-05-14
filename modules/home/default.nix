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
        background-opacity = 0.85;
        window-theme = "auto";
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
        display.separator = " ";
        modules = [
          { type = "custom"; format = "╭──────────────────────────────────────────╮"; }
          { type = "os"; key = "  OS:"; keyColor = "red"; }
          { type = "kernel"; key = "  Kernel:"; keyColor = "red"; }
          { type = "uptime"; key = "  Uptime:"; keyColor = "red"; }
          { type = "packages"; key = "  Packages:"; keyColor = "green"; }
          { type = "wm"; key = "  WM:"; keyColor = "yellow"; }
          { type = "shell"; key = "  Shell:"; keyColor = "yellow"; }
          { type = "terminal"; key = "  Terminal:"; keyColor = "yellow"; }
          { type = "localip"; key = "  Local IP:"; keyColor = "yellow"; }
          { type = "custom"; format = "╰──────────────────────────────────────────╯"; }
          "break"
          { type = "custom"; format = "╭──────────────────────────────────────────╮"; }
          { type = "cpu"; format = "{1}"; key = "  CPU:"; keyColor = "blue"; }
          { type = "gpu"; format = "{2}"; key = "  GPU:"; keyColor = "blue"; }
          { type = "memory"; key = "  Memory:"; keyColor = "magenta"; }
          { type = "disk"; key = "  Disk:"; keyColor = "green"; }
          { type = "custom"; format = "╰──────────────────────────────────────────╯"; }
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
    ];

    wayland.windowManager.sway = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "ghostty";
        menu = "${pkgs.tofi}/bin/tofi-drun --drun-launch=true";
        gaps = {
          inner = 10;
          outer = 10;
        };
        window = {
          border = 3;
          titlebar = false;
        };
        colors = {
          focused = {
            border = "#ebbcba";
            background = "#ebbcba";
            text = "#191724";
            indicator = "#ebbcba";
            childBorder = "#ebbcba";
          };
          unfocused = {
            border = "#00000000";
            background = "#00000000";
            text = "#908caa";
            indicator = "#00000000";
            childBorder = "#00000000";
          };
        };
        keybindings = let
          sway = "swaymsg";
        in {
          "Mod1+Return" = "fullscreen";
          "Mod1+q" = "kill";
          "Mod1+f1" = "reload";
          "Mod1+Shift+f4" = "exit";
          "Mod4+Return" = "exec ghostty";
          "Mod1+Space" = "exec ${pkgs.tofi}/bin/tofi-drun --drun-launch=true";
          "Mod1+s" = "exec ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only";
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.5";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        } // builtins.listToAttrs (map (num: let
          s = toString num;
        in {
          "Mod1+${s}" = "workspace number ${s}";
          "Mod1+Shift+${s}" = "move container to workspace number ${s}";
        }) (builtins.genList (x: x + 1) 9));
      };
    };
  };
}
