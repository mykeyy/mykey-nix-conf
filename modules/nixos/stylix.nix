{
  flake.modules.nixos.stylix = { inputs, pkgs, lib, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      autoEnable = true;
      polarity = "dark";
      image = ../../wallpapers/wallpaper.jpg;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      targets.regreet.enable = false;
      targets.qt.platform = lib.mkForce "qtct";
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
          package = pkgs.stdenv.mkDerivation {
            pname = "apple-color-emoji";
            version = "26";
            src = pkgs.fetchurl {
              url = "https://github.com/samuelngs/apple-emoji-ttf/releases/download/macos-26-20260219-2aa12422/AppleColorEmoji-Linux.ttf";
              sha256 = "sha256-U1oEOvBHBtJEcQWeZHRb/IDWYXraLuo0NdxWINwPUxg=";
            };
            dontUnpack = true;
            installPhase = ''
              mkdir -p $out/share/fonts/truetype
              cp $src $out/share/fonts/truetype/AppleColorEmoji.ttf
            '';
          };
          name = "Apple Color Emoji";
        };
      };
    };
  };
}
