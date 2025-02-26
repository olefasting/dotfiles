function __install_module() {
  if ! has-pkg ghostty; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS ghostty ghostty-shell-integration"
  fi
  create-dir config ghostty
  create-symlink ghostty/config
  return 0
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg ghostty; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS ghostty ghostty-shell-integration"
  fi
  remove-symlink ghostty/config
  remove-dir config ghostty
  return 0
}
