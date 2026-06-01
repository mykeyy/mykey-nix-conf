{ ... }: {
  # Plasma theming is managed via static config files below.
  # Disable Stylix's Plasma target to prevent it from running
  # plasma-apply-lookandfeel and xrdb at activation time (before
  # any display is available), which causes noisy boot errors.
  stylix.targets.plasma.enable = false;

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
