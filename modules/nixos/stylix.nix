{
  flake.modules.nixos.stylix = { inputs, pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      autoEnable = true;
      polarity = "dark";
      image = pkgs.runCommand "wallpaper.png" {
        nativeBuildInputs = [ pkgs.imagemagick ];
      } ''
        convert -size 1920x1080 xc:'#191724' $out
      '';
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
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans Mono";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  };
}
