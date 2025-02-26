function __install_module() {
  require zig
  if ! has-pkg zls and ! has-pkg zls-git; then
    eval "pacman $_PACMAN_INSTALL_ARGS zls"
  fi
  create-symlink zls/config.json zls.json
  return 0
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg zls; then
    eval "pacman $_PACMAN_UNINSTALL_ARGS zls"
  fi
  remove-symlink zls/config.json zls.json
  return 0
}
