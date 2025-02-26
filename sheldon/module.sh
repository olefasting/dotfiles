function __install_module() {
  local _shell="${DOTFILES_SHELL:-$(basename "$SHELL")}"
  if ! is-installed "$_shell"; then
    require "$_shell"
  fi
  if ! has-pkg sheldon; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS sheldon"
  fi
  local _filename="plugins.${_shell}.toml"
  if [[ ! -e "$DOTFILES_DIR/sheldon/$_filename" ]]; then
    error "install_sheldon($_shell) the config file for shell '$_shell' could not be found ($DOTFILES_DIR/sheldon/$_filename)"
    return 1
  fi
  create-dir config sheldon
  create-dir data sheldon
  create-symlink "sheldon/${_filename}" sheldon/plugins.toml
  case "$_shell" in
  zsh)
    if [[ ! -e "$XDG_CONFIG_HOME/zsh/zshrc.d" ]]; then
      warning "install sheldon: user shell is '$_shell' but the installer could not find the zshrc.d directory. Manually source '\$PWD/sheldon/for-zshrc.zsh' at the end of .zshrc to fix this"
    else
      create-symlink sheldon/for-zshrc.zsh zsh/zshrc.d/9999-sheldon-zsh.zsh
    fi
    ;;
  *)
    warning "install sheldon: unable to determine user shell, or user shell is unknown. Manually determine how to initialize sheldon with your shell"
    ;;
  esac
  return 0
}

function __uninstall_module() {
  local _shell="${DOTFILES_SHELL:-$(basename "$SHELL")}"
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg sheldon; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS sheldon"
  fi
  remove-symlink sheldon/plugins.toml
  remove-dir config sheldon
  remove-dir data sheldon
  case "$_shell" in
  zsh)
    if [[ ! -e "$XDG_CONFIG_HOME/zsh/zshrc.d" ]]; then
      warning "uninstall sheldon: user shell is '$_shell' but the installer could not find the zshrc.d directory. Manually remove any sourcing of '\$PWD/sheldon/for-zshrc.zsh' from .zshrc to fix this"
    else
      remove-symlink zsh/zshrc.d/9999-sheldon-zsh.zsh
    fi
    ;;
  esac
  return 0
}
