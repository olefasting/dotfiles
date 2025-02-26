function __install_module() {
  if ! has-pkg biome-bin; then
    eval "yay $_PACMAN_INSTALL_ARGS biome-bin"
  fi
  create-dir config biome
  create-symlink biome/biome.json
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg biome-bin; then
    eval "yay $_PACMAN_UNINSTALL_ARGS biome-bin"
  fi
  remove-symlink biome/biome.json
  remove-dir config biome
}
