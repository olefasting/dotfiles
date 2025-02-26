function __install_module() {
  if ! has-pkg ufw; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS ufw ufw-extras"
  fi
  sudo ufw allow "KDE Connect"
  return 0
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg ufw; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS ufw ufw-extras"
  elif has-pkg ufw; then
    sudo ufw delete "KDE Connect"
  fi
  return 0
}
