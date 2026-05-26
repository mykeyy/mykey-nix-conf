{ pkgs, ... }: {
  home.packages = with pkgs; [
    fd
    btop
    gh
    glab
    lazygit
    prismlauncher
    nh
    yazi
    obs-studio
    killall
    unzip
    opencode
    tofi
    swaybg
    swaylock
    wl-clipboard
    grim
    slurp
    spotify
    spicetify-cli
    nerd-fonts.jetbrains-mono
    eww
    vivid
    playerctl
    bluez
    bluetuith
    antigravity
    nodejs
    bun
    libreoffice-qt-fresh
    libnotify
    jq
    xclip
    satty
    (callPackage ../../tools/screenshot { })
    (pkgs.writeShellScriptBin "annotate" ''
      ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | \
        ${pkgs.satty}/bin/satty --filename - --fullscreen --copy-command ${pkgs.wl-clipboard}/bin/wl-copy
    '')
    (pkgs.writeShellScriptBin "power-menu" ''
      logout() {
        if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
          hyprctl dispatch exit
        elif [ -n "$SWAYSOCK" ]; then
          swaymsg exit
        else
          loginctl terminate-session "$XDG_SESSION_ID"
        fi
      }

      pick() {
        printf '%s\n' "$@" | ${pkgs.tofi}/bin/tofi --prompt-text "power: "
      }

      ACTION=$(pick Lock Logout Suspend Restart Shutdown)

      case "$ACTION" in
        "Lock")
          ${pkgs.swaylock}/bin/swaylock
          ;;
        "Logout")
          CONFIRM=$(pick Yes No)
          [ "$CONFIRM" = "Yes" ] && logout
          ;;
        "Suspend")
          CONFIRM=$(pick Yes No)
          [ "$CONFIRM" = "Yes" ] && systemctl suspend
          ;;
        "Restart")
          CONFIRM=$(pick Yes No)
          [ "$CONFIRM" = "Yes" ] && systemctl reboot
          ;;
        "Shutdown")
          CONFIRM=$(pick Yes No)
          [ "$CONFIRM" = "Yes" ] && systemctl poweroff
          ;;
      esac
    '')
  ];
}
