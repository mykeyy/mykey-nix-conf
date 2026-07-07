{ pkgs, ... }: {
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    image = ../../wallpapers/wallpaper.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    targets.gtk.enable = true;
  };

  xdg.configFile = {
    "kglobalshortcutsrc".source = ../../configs/kglobalshortcutsrc;
    "kwinrc".source = ../../configs/kwinrc;
    "plasmashellrc".source = ../../configs/plasmashellrc;
    "plasmarc".source = ../../configs/plasmarc;
    "plasma-localerc".source = ../../configs/plasma-localerc;
    "plasma-org.kde.plasma.desktop-appletsrc".source = ../../configs/plasma-org.kde.plasma.desktop-appletsrc;
    "ghostty/themes/rose-pine".source = ../../configs/ghostty-rose-pine;
  };
}
