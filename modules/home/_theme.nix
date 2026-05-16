{ ... }: {
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
