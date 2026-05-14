{ config, inputs, rootPath, ... }:
{
  flake.modules.homeManager.base = { pkgs, ... }: {
    imports = [ inputs.nixcord.homeModules.nixcord ];

    home.username = "mykey";
    home.homeDirectory = "/home/mykey";
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;

    home.shellAliases = {
      fuckoff = "exit";
    };

    programs.ghostty = {
      enable = true;
      settings = {
        font-size = 14;
        theme = "rose-pine";
        background-opacity = 0.95;
        command = "${pkgs.nushell}/bin/nu";
        keybind = [
          "alt+1=unbind"
          "alt+2=unbind"
          "alt+3=unbind"
          "alt+4=unbind"
          "alt+5=unbind"
          "alt+6=unbind"
          "alt+7=unbind"
          "alt+8=unbind"
          "alt+9=unbind"
        ];
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
        cd ~
      '';
      extraConfig = ''
        def create_left_prompt [] {
          let path = (ansi blue) + ($env.PWD | str replace $env.HOME "~")
          $path + (ansi reset) + "\n"
        }
        $env.PROMPT_COMMAND = { || create_left_prompt };
        $env.PROMPT_INDICATOR = { || $"(ansi green)λ(ansi reset) " };
        ${pkgs.fastfetch}/bin/fastfetch
      '';
    };

    programs.oh-my-posh.enable = false;

    programs.ghostty = {
      enable = true;
      settings = {
        font-size = 16;
        theme = "Rose Pine";
        background-opacity = 0.85;
        command = "${pkgs.nushell}/bin/nu";
        keybind = [
          "alt+1=unbind" "alt+2=unbind" "alt+3=unbind"
          "alt+4=unbind" "alt+5=unbind" "alt+6=unbind"
          "alt+7=unbind" "alt+8=unbind" "alt+9=unbind"
        ];
      };
    };

    programs.starship.enable = false;

    programs.fastfetch = {
      enable = true;
      settings = {
        logo.source = "nixos";
        display = {
          size.binaryPrefix = "si";
          color = "blue";
          separator = "  ";
        };
        modules = [
          { type = "os"; key = "os   "; keyColor = "blue"; format = "{name} {version}"; }
          { type = "kernel"; key = "krnl "; keyColor = "blue"; }
          { type = "packages"; key = "pkgs "; keyColor = "blue"; }
          { type = "shell"; key = "shell"; keyColor = "blue"; }
          "break"
          { type = "wm"; key = "wm   "; keyColor = "red"; }
          { type = "terminal"; key = "term "; keyColor = "red"; }
          { type = "font"; key = "font "; keyColor = "red"; }
          { type = "icons"; key = "icon "; keyColor = "red"; }
          "break"
          { type = "cpu"; key = "cpu  "; keyColor = "green"; }
          { type = "memory"; key = "mem  "; keyColor = "green"; }
          { type = "gpu"; key = "gpu  "; keyColor = "green"; }
          { type = "disk"; key = "disk "; keyColor = "green"; }
          "break"
          { type = "localip"; key = "ip   "; keyColor = "yellow"; }
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
      "eww/eww.yuck".source = ../../configs/eww/eww.yuck;
      "eww/eww.scss".source = ../../configs/eww/eww.scss;
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
      package = pkgs.swayfx;
      checkConfig = false;
      extraConfig = ''
        corner_radius 8
        blur enable
        blur_xray disable
        blur_passes 1
        shadows enable
        shadows_on_csd enable
        layer_effects "swaybar" blur enable; corner_radius 8
        workspace 1 output *
        workspace 2 output *
        workspace 3 output *
        workspace 4 output *
        workspace 5 output *
        exec swaybg -i ${../../wallpapers/wallpaper.jpg} -m fill
        exec eww open bar
        exec systemctl --user restart xdg-desktop-portal-wlr
      '';
      config = {
        modifier = "Mod4";
        terminal = "ghostty";
        menu = "${pkgs.tofi}/bin/tofi-drun --drun-launch=true";
        output."*".bg = "${../../wallpapers/wallpaper.jpg} fill";
        gaps = {
          inner = 12;
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
          "Mod4+Shift+e" = "exit";
          "Mod4+Shift+q" = "kill";
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
