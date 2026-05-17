{ pkgs, ... }: {
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
      | prepend "/run/current-system/sw/bin"
      | prepend "/nix/var/nix/profiles/default/bin"
      | prepend ($"/etc/profiles/per-user/(whoami)/bin")
      | prepend ($"($env.HOME)/.nix-profile/bin")
      | prepend "/run/wrappers/bin"
      | uniq
    '';
    extraConfig = ''
      #!/bin/nu
      $env.LS_COLORS = (${pkgs.vivid}/bin/vivid generate rose-pine)

      export def --env gc [
        source: string,
        target?: string,
        --cd(-c)
        --only-hm (-H)
        --only-config (-C)
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
              _ => { print $"Unsupported SSH provider: ($provider)"; return }
            }
          } else {
            match $provider {
              "github" => $"https://github.com/($repo).git"
              "gitlab" => $"https://gitlab.com/($repo).git"
              _ => { print $"Unsupported provider: ($provider)"; return }
            }
          }
          let target_dir = if ($target != null) { $target } else { $repo | split row "/" | last }
          print $"Cloning from ($url) into ($target_dir)"
          git clone $url $target_dir
          if $cd { cd $target_dir }
      }

      export def dev [] {
        nix develop --command nu
      }

      export def rebuild [--update (-u)] {
        let flake = $"($env.HOME)/.nix"
        if $update { nix flake update $flake }
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
        { type = "custom"; format = "╭─────────────────────────────────────────────────────╮"; }
        { type = "os"; key = "    OS:"; keyColor = "red"; }
        { type = "kernel"; key = "    Kernel:"; keyColor = "red"; }
        { type = "command"; key = "  󱦟  OS Age:"; keyColor = "31";
          text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days"; }
        { type = "uptime"; key = "  󱫐  Uptime:"; keyColor = "red"; }
        { type = "packages"; key = "  󰏓  Packages:"; keyColor = "green"; }
        { type = "wm"; key = "    WM:"; keyColor = "yellow"; }
        { type = "shell"; key = "    Shell:"; keyColor = "yellow"; }
        { type = "terminal"; key = "    Terminal:"; keyColor = "yellow"; }
        { type = "localip"; key = "    Local IP:"; keyColor = "yellow"; }
        { type = "custom"; format = "╰─────────────────────────────────────────────────────╯"; }
        "break"
        { type = "title"; key = "  :"; }
        { type = "custom"; format = "╭─────────────────────────────────────────────────────╮"; }
        { type = "cpu"; format = "{1}"; key = "    CPU:"; keyColor = "blue"; }
        { type = "gpu"; format = "{2}"; key = "    GPU:"; keyColor = "blue"; }
        { type = "gpu"; format = "{3}"; key = "    GPU Driver:"; keyColor = "magenta"; }
        { type = "memory"; key = "    Memory:"; keyColor = "magenta"; }
        { type = "disk"; key = "  󰋊  Disk:"; keyColor = "green"; }
        { type = "custom"; key = "    GitHub:"; format = "mykeyy"; }
        { type = "custom"; key = " "; format = "╰─────────────────────────────────────────────────────╯"; }
      ];
    };
  };
}
