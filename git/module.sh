function __install_module() {
  if ! has-pkg git; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS git"
  fi
  create-symlink git/gitconfig "$HOME/.gitconfig"
  return 0
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg git; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS git"
  fi
  remove-symlink "$HOME/.gitconfig"
  return 0
}
