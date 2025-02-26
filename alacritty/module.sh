function __install_module() {
  if ! has-pkg alacritty; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS alacritty"
  fi
  create-dir config alacritty
  create-symlink alacritty/alacritty.toml
  create-symlink alacritty/catppuccin-mocha.toml
  return 0
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg alacritty; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS alacritty"
  fi
  remove-symlink alacritty/alacritty.toml
  remove-symlink alacritty/catppuccin-mocha.toml
  remove-dir config alacritty
  return 0
}
