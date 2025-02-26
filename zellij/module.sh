function __install_module() {
  if ! has-pkg zellij; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS zellij"
  fi
  create-dir config zellij
  create-dir data zellij
  create-symlink zellij/config.kdl
  create-symlink zellij/layouts
  create-symlink zellij/plugins
  create-symlink zellij/themes
  return 0
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg zellij; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS zellij"
  fi
  remove-symlink zellij/config.kdl
  remove-symlink zellij/layouts
  remove-symlink zellij/plugins
  remove-symlink zellij/themes
  remove-dir config zellij
  remove-dir data zellij
  return 0
}
