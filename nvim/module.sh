function __install_module() {
  if ! has-pkg neovim; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS neovim neovim-lspconfig"
  fi
  create-dir config nvim
  create-dir data nvim
  create-symlink nvim/init.lua
  create-symlink nvim/lazy-lock.json
  create-symlink nvim/lua
  return 0
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg neovim; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS neovim neovim-lspconfig"
  fi
  remove-symlink nvim/init.lua
  remove-symlink nvim/lazy-lock.json
  remove-symlink nvim/lua
  remove-dir config nvim
  remove-dir data nvim
  return 0
}
