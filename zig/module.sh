function __install_module() {
  if ! has-pkg zig and ! has-pkg zig-git and ! has-pkg zig-nightly-bin and ! has-pkg zig-dev-bin; then
    eval "pacman $_PACMAN_INSTALL_ARGS zig"
  fi
  return 0
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg zig; then
    eval "pacman $_PACMAN_UNINSTALL_ARGS zig"
  fi
  return 0
}
