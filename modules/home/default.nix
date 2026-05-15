{ config, inputs, rootPath, ... }:
{
  flake.modules.homeManager.base = { pkgs, ... }: {
    imports = [ inputs.nixcord.homeModules.nixcord ];

    home.username = "mykey";
    home.homeDirectory = "/home/mykey";
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;
    gtk.gtk4.theme = null;

    home.shellAliases = {
      fuckoff = "exit";
    };

    programs.nushell = {
      enable = true;

      settings = {
        show_banner = false;
        use_kitty_protocol = true;
        buffer_editor = "hx";

        completions.external = {
          enable = true;
          max_results = 10000;
        };
      };

      shellAliases = {
        fuckoff = "exit";
        spotify = "spotify_player";
      };

      extraEnv = ''
        $env.EDITOR = "${pkgs.helix}/bin/hx";
        $env.VISUAL = "${pkgs.helix}/bin/hx";
        $env.NH_FLAKE = $"($env.HOME)/.nix";
        $env.NH_OS_FLAKE = $"($env.HOME)/.nix";
        $env.NH_DARWIN_FLAKE = $"($env.HOME)/.nix";
        $env.NH_HOME_FLAKE = $"($env.HOME)/.nix";
        $env.PATH = ($env.PATH | split row (char esep))
        | prepend "/run/wrappers/bin"
        | prepend ($"($env.HOME)/.nix-profile/bin")
        | prepend ($"/etc/profiles/per-user/(whoami)/bin")
        | prepend "/nix/var/nix/profiles/default/bin"
        | prepend "/run/current-system/sw/bin"
        | uniq
      '';

      extraConfig = ''
        #!/bin/nu
        $env.LS_COLORS = (${pkgs.vivid}/bin/vivid generate rose-pine)

        export def --env gc [
          source: string, # Repository to clone (e.g gitlab:invranet/nix-conf or ssh:gitlab:invranet/nix-conf)
          target?: string, # Location to clone to.
          --cd(-c) # Whether to cd into new target.
          --only-hm (-H) # Only build output for Home-manager, and switch.
          --only-config (-C) # Only build output for Configuration, and switch.
        ] {
            let parts = ($source | split row ":")
            if ($parts | length) < 2 {
              print $"(ansi red_bold)Error:(ansi reset) ($source) is not how you specify a repo. Use help \(-h\) to check.."

              return
            }

            let is_ssh = $parts.0 == "ssh"
            let provider = if $is_ssh { $parts.1 } else { $parts.0 }
            let repo = if $is_ssh { $parts.2 } else { $parts.1 }

            let url = if $is_ssh {
              match $provider {
                "github" => $"git@github.com:($repo).git"
                "gitlab" => $"git@gitlab.com:($repo).git"
                _ => {
                  print $"Unsupported SSH provider: ($provider)"
                  return
                }
              }
            } else {
              match $provider {
                "github" => $"https://github.com/($repo).git"
                "gitlab" => $"https://gitlab.com/($repo).git"
                _ => {
                  print $"Unsupported provider: ($provider)"
                  return
                }
              }
            }

            let target_dir = if ($target != null) {
              $target
            } else {
              $repo | split row "/" | last
            }

            print $"Cloning from ($url) into ($target_dir)"
            git clone $url $target_dir

            if $cd {
              cd $target_dir
            }
        }

        export def dev [] {
          nix develop --command nu
        }

        export def rebuild [--update (-u)] {
          let flake = $"($env.HOME)/.nix"
          if $update {
            nix flake update $flake
          }
          /run/wrappers/bin/sudo nixos-rebuild switch --flake $"($flake)#tp490s"
        }

        if not ("x" in $env) {
          ${pkgs.fastfetch}/bin/fastfetch
        }

        $env.x = true

        mkdir ($nu.data-dir | path join "vendor/autoload")
        ${pkgs.starship}/bin/starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
      '';
    };

    programs.starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ../../configs/starship.toml);
    };

    programs.zoxide = {
      enable = true;
      enableNushellIntegration = true;
      options = [ "--cmd cd" ];
    };

    programs.carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = ../../configs/fastfetch-logo.png;
          width = 54;
          height = 22;
          type = "kitty-direct";
        };
        display.separator = " ";
        modules = [
          {
            type = "custom";
            format = "╭─────────────────────────────────────────────────────╮";
          }
          {
            type = "os";
            key = "    OS:";
            keyColor = "red";
          }
          {
            type = "kernel";
            key = "    Kernel:";
            keyColor = "red";
          }
          {
            type = "command";
            key = "  󱦟  OS Age:";
            keyColor = "31";
            text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
          }
          {
            type = "uptime";
            key = "  󱫐  Uptime:";
            keyColor = "red";
          }
          {
            type = "packages";
            key = "  󰏓  Packages:";
            keyColor = "green";
          }
          {
            type = "wm";
            key = "    WM:";
            keyColor = "yellow";
          }
          {
            type = "shell";
            key = "    Shell:";
            keyColor = "yellow";
          }
          {
            type = "terminal";
            key = "    Terminal:";
            keyColor = "yellow";
          }
          {
            type = "localip";
            key = "    Local IP:";
            keyColor = "yellow";
          }
          {
            type = "custom";
            format = "╰─────────────────────────────────────────────────────╯";
          }
          "break"
          {
            type = "title";
            key = "  :";
          }
          {
            type = "custom";
            format = "╭─────────────────────────────────────────────────────╮";
          }
          {
            type = "cpu";
            format = "{1}";
            key = "    CPU:";
            keyColor = "blue";
          }
          {
            type = "gpu";
            format = "{2}";
            key = "    GPU:";
            keyColor = "blue";
          }
          {
            type = "gpu";
            format = "{3}";
            key = "    GPU Driver:";
            keyColor = "magenta";
          }
          {
            type = "memory";
            key = "    Memory:";
            keyColor = "magenta";
          }
          {
            type = "disk";
            key = "  󰋊  Disk:";
            keyColor = "green";
          }
          {
            type = "custom";
            key = "    GitHub:";
            format = "mykeyy";
          }
          {
            type = "custom";
            key = " ";
            format = "╰─────────────────────────────────────────────────────╯";
          }
        ];
      };
    };

    programs.ghostty = {
      enable = true;
      settings = {
        theme = "rose-pine";
        background-opacity = 0.95;
        font-size = 14;
        command = "${pkgs.nushell}/bin/nu";
      };
    };

    stylix.targets.ghostty.enable = false;
    stylix.targets.tofi.enable = false;
    stylix.targets.mako.enable = false;
    stylix.targets.spotify-player.enable = false;

    programs.spotify-player = {
      enable = true;
      settings = {
        theme = "rose-pine";
        notify_format = {
          summary = "{track}";
          body = "{artists} - {album}";
        };
        playback_refresh_duration_in_ms = 500;
        device = {
          volume = 40;
          bitrate = 320;
        };
        layout = {
          playback_window_position = "Bottom";
          library = {
            playlist_percent = 60;
            album_percent = 20;
          };
        };
      };
    };

    programs.tofi = {
      enable = true;
      settings = {
        prompt-text = "> ";
        text-color = "#e0def4";
        prompt-color = "#ebbcba";
        selection-color = "#c4a7e7";
        background-color = "#191724e6";
        width = "100%";
        padding-left = "35%";
        padding-top = "25%";
        height = "100%";
        border-width = 0;
        outline-width = 0;
        result-spacing = 10;
        num-results = 14;
        font = "JetBrainsMono Nerd Font";
        font-size = 22;
      };
    };

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

    programs.vscodium = {
      enable = true;
    };

    programs.eww = {
      enable = true;
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
      "spotify-player/theme.toml".source = ../../configs/spotify-player-theme.toml;
      "eww/eww.yuck".source = ../../configs/eww/eww.yuck;
      "eww/eww.scss".source = ../../configs/eww/eww.scss;
      "tofi/menu".text = ''
        prompt-text = "power: "
        text-color = "#e0def4"
        prompt-color = "#ebbcba"
        selection-color = "#c4a7e7"
        background-color = "#191724e6"
        width = "20%"
        height = "25%"
        padding-left = "40%"
        padding-top = "38%"
        border-width = 2
        outline-width = 0
        result-spacing = 15
        num-results = 5
        font = "JetBrainsMono Nerd Font"
        font-size = 20
      '';
    };

    services.cliphist.enable = true;

    services.mako = {
      enable = true;
      settings = {
        background-color = "#191724CC";
        text-color = "#e0def4";
        border-color = "#c4a7e7";
        border-size = 2;
        border-radius = 8;
        font = "JetBrainsMono Nerd Font 12";
        default-timeout = 5000;
        anchor = "top-right";
        margin = "12,12";
        padding = "8,12";
      };
    };

    systemd.user.services.clipboard-sync = {
      Unit = {
        Description = "Sync Wayland clipboard to X11 clipboard";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.wl-clipboard}/bin/wl-copy";
        Restart = "always";
        RestartSec = 1;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
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
      wl-clipboard
      grim
      slurp
      spotify
      spicetify-cli
      nerd-fonts.jetbrains-mono
      eww
      vivid
      playerctl
       bluez
       libnotify
       xclip
       (pkgs.writeShellScriptBin "screenshot" ''
         mkdir -p "$HOME/Pictures/screenshots"
         FILE="$HOME/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"
         ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "$FILE"
         ${pkgs.wl-clipboard}/bin/wl-copy --type image/png < "$FILE"
         echo -n "$FILE" | ${pkgs.wl-clipboard}/bin/wl-copy --primary
         notify-send "Screenshot saved" "$FILE"
       '')
       (pkgs.writeShellScriptBin "power-menu" ''
        ACTION=$(printf "Lock\nLogout\nSuspend\nRestart\nShutdown\n" | ${pkgs.tofi}/bin/tofi --config "$HOME/.config/tofi/menu")

        case "$ACTION" in
          "Lock")
            ${pkgs.swaylock}/bin/swaylock
            ;;
          "Logout")
            CONFIRM=$(printf "Yes\nNo" | ${pkgs.tofi}/bin/tofi --config "$HOME/.config/tofi/menu")
            [ "$CONFIRM" = "Yes" ] && swaymsg exit
            ;;
          "Suspend")
            CONFIRM=$(printf "Yes\nNo" | ${pkgs.tofi}/bin/tofi --config "$HOME/.config/tofi/menu")
            [ "$CONFIRM" = "Yes" ] && systemctl suspend
            ;;
          "Restart")
            CONFIRM=$(printf "Yes\nNo" | ${pkgs.tofi}/bin/tofi --config "$HOME/.config/tofi/menu")
            [ "$CONFIRM" = "Yes" ] && systemctl reboot
            ;;
          "Shutdown")
            CONFIRM=$(printf "Yes\nNo" | ${pkgs.tofi}/bin/tofi --config "$HOME/.config/tofi/menu")
            [ "$CONFIRM" = "Yes" ] && systemctl poweroff
            ;;
        esac
      '')
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
        bars = [ ];
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
          "Mod4+Shift+e" = "exec power-menu";
          "Mod4+Shift+q" = "kill";
          "Mod4+l" = "exec ${pkgs.swaylock}/bin/swaylock";
          "Mod4+Return" = "exec ghostty";
          "Mod1+Space" = "exec ${pkgs.tofi}/bin/tofi-drun --drun-launch=true";
          "Mod1+s" = "exec screenshot";
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
