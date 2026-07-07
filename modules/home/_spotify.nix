{ pkgs, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  stylix.targets.spotify-player.enable = false;
  stylix.targets.spicetify.enable = false;
  xdg.configFile."spotify-player/theme.toml".source = ../../configs/spotify-player-theme.toml;

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

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.comfy;
    colorScheme = "rose-pine";

    enabledExtensions = with spicePkgs.extensions; [
      spicyLyrics
      trashbin
    ];
  };
}
