function __install_module() {
  if ! has-pkg contour; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS contour"
  fi
  create-dir config contour
  create-symlink contour/contour.yml
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg contour; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS contour"
  fi
  remove-symlink contour/contour.yml
  remove-dir config contour
}
