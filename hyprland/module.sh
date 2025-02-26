function __install_module() {
  if ! has-pkg hyprland; then
    eval "yay $_PACMAN_INSTALL_ARGS hyprland hyprland-protocols hyprland-qt-support hyprland-qtutils hyprland-target hyprland-workspaces xdg-desktop-portal-hyprland hyprpolkitagent hyprcursor hyprlock hypridle hyprpaper uwsm wofi waybar"
  fi
  create-dir config hypr
  create-symlink hyprland/hyprland.conf hypr/hyprland.conf
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg hyprland; then
    eval "yay $_PACMAN_UNINSTALL_ARGS hyprland hyprland-protocols hyprland-qt-support hyprland-qtutils hyprland-target hyprland-workspaces xdg-desktop-portal-hyprland hyprpolkitagent hyprcursor hyprlock hypridle hyprpaper uwsm wofi waybar"
  fi
  remove-symlink hypr/hyprland.conf
  remove-dir config hypr
}
