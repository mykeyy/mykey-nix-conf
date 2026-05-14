{
  flake.modules.nixos.stylix = { inputs, pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      autoEnable = true;
      polarity = "dark";
      image = ../../wallpapers/wallpaper.jpg;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      fonts = {
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        emoji = {
          package = pkgs.apple-color-emoji;
          name = "Apple Color Emoji";
        };
      };
    };
  };
}
