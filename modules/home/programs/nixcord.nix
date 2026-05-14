{ config, inputs, ... }:
{
  flake.modules.homeManager.nixcord = {
    imports = [ inputs.nixcord.homeModules.nixcord ];

    programs.nixcord = {
      enable = true;
      vesktop.enable = true;
      quickCss = builtins.readFile ../../../../quickcss.nix;
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
  };
}
