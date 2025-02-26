function __install_module() {
  if ! has-pkg tree-sitter; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS tree-sitter"
  fi
  create-dir config tree-sitter
  create-symlink tree-sitter/config.json
  return 0
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg tree-sitter; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS tree-sitter"
  fi
  remove-symlink tree-sitter/config.json
  remove-dir config tree-sitter
  return 0
}
