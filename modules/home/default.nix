{ config, inputs, rootPath, ... }:
{
  flake.modules.homeManager.base = { pkgs, lib, config, ... }: {
    imports = [
      inputs.nixcord.homeModules.nixcord
      ./_core.nix
      ./_shell.nix
      ./_terminal.nix
      ./_launcher.nix
      ./_bar.nix
      ./_mako.nix
      ./_packages.nix
      ./_theme.nix
      ./_apps.nix
      ./_clipboard.nix
      ./_spotify.nix
      ./_sway.nix
      ./_hyprland.nix
      ./_hyprpaper.nix
    ];

    gtk.gtk4.theme = config.gtk.theme;

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
  };
}
