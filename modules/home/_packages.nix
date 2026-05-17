{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    bat
    ripgrep
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
    wget
    tofi
    swaybg
    swaylock
    hyprshot
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
    libnotify
      jq
      xclip
    (pkgs.writeShellScriptBin "screenshot" ''
      mkdir -p "$HOME/Pictures/screenshots"
      FILE="$HOME/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"
      ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "$FILE"
      ${pkgs.wl-clipboard}/bin/wl-copy --type image/png < "$FILE"
      echo -n "$FILE" | ${pkgs.wl-clipboard}/bin/wl-copy --primary
      notify-send "Screenshot saved" "$FILE"
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
