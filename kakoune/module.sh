function __install_module() {
  if ! has-pkg kakoune; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS kakoune kakoune-lsp"
  fi
  create-dir config kak
  create-dir data kak
  create-symlink kakoune/kakrc kak/kakrc
  create-symlink kakoune/kak-lsp.toml kak/kak-lsp.toml
  create-symlink kakoune/autoload kak/autoload
  create-symlink kakoune/colors kak/colors
  return 0
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg kakoune; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS kakoune kakoune-lsp"
  fi
  remove-symlink kakoune/kakrc kak/kakrc
  remove-symlink kakoune/kak-lsp.toml kak/kak-lsp.toml
  remove-symlink kakoune/autoload kak/autoload
  remove-symlink kakoune/colors kak/colors
  remove-dir config kak
  remove-dir data kak
  return 0
}
