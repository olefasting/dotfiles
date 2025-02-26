function __install_module() {
  if ! has-pkg plasma-desktop; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS plasma-desktop plasma-browser-integration"
  fi
  local _fname="plasma-org.kde.plasma.desktop-appletsrc"
  create-symlink "kde-plasma/$_fname" "$_fname"
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg plasma-desktop; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS plasma-desktop plasma-browser-integration"
  fi
  create-symlink plasma-org.kde.plasma.desktop-appletsrc
}
