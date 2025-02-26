function __install_module() {
  if ! has-pkg zed; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS zed"
  fi
  create-dir config zed
  create-dir data zed
  create-symlink zed/settings.json
  return 0
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg zed; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS zed"
  fi
  remove-symlink zed/settings.json
  remove-dir config zed
  remove-dir data zed
  return 0
}
