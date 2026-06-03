{ config, inputs, rootPath, ... }:
{
  flake.modules.homeManager.base = { pkgs, lib, config, ... }: {
    imports = [
      inputs.nixcord.homeModules.nixcord
      inputs.spicetify-nix.homeManagerModules.default
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
      ./_swayidle.nix
      ./_river.nix
    ];

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    programs.nixcord = {
      enable = true;
      vesktop.enable = false;
      discord.vencord.enable = true;
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
