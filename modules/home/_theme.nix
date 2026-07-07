{ pkgs, ... }: {
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.apple-cursor;
    name = "macOS";
    size = 24;
  };

  gtk = {
    enable = true;
    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
    font = {
      name = "DejaVu Sans";
      size = 11;
    };
    gtk4.theme = null;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  xdg.configFile = {
    "kglobalshortcutsrc".source = ../../configs/kglobalshortcutsrc;
    "kwinrc".source = ../../configs/kwinrc;
    "plasmashellrc".source = ../../configs/plasmashellrc;
    "plasmarc".source = ../../configs/plasmarc;
    "plasma-localerc".source = ../../configs/plasma-localerc;
    "plasma-org.kde.plasma.desktop-appletsrc".source = ../../configs/plasma-org.kde.plasma.desktop-appletsrc;
    "ghostty/themes/rose-pine".source = ../../configs/ghostty-rose-pine;
    "gtk-4.0/assets".source = "${pkgs.rose-pine-gtk-theme}/share/themes/rose-pine/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${pkgs.rose-pine-gtk-theme}/share/themes/rose-pine/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${pkgs.rose-pine-gtk-theme}/share/themes/rose-pine/gtk-4.0/gtk-dark.css";
  };
}
