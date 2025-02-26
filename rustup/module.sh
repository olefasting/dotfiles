function __install_module() {
  if ! has-pkg rustup; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS rustup"
  fi
  return 0
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg rustup; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS rustup"
  fi
}
