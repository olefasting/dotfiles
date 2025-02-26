function __install_module() {
  local _shell="${DOTFILES_SHELL:-$(basename "$SHELL")}"
  require "$_shell"
  if ! has-pkg starship; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS starship"
  fi
  create-dir config starship
  create-symlink starship/starship.toml
  case "$_shell" in
  zsh)
    if [[ ! -e "$XDG_CONFIG_HOME/zsh/zshrc.d" ]]; then
      warning "install starship: user shell is '$_shell' but the installer could not find the zshrc.d directory. Manually source '\$PWD/starship/for-zshrc.zsh' at the end of .zshrc to fix this"
    else
      create-symlink starship/for-zshrc.zsh zsh/zshrc.d/9999-starship-prompt.zsh
    fi
    ;;
  *)
    warning "install starship: unable to determine user shell, or user shell is unknown. Manually determine how to initialize starship with your shell"
    ;;
  esac
  return 0
}

function __uninstall_module() {
  local _shell="${DOTFILES_SHELL:-$(basename "$SHELL")}"
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg starship; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS starship"
  fi
  case "$_shell" in
  zsh)
    if [[ ! -e "$XDG_CONFIG_HOME/zsh/zshrc.d" ]]; then
      warning "uninstall starship: user shell is '$_shell' but the uninstaller could not find the zshrc.d directory. Manually remove any sourcing of '\$PWD/starship/for-zshrc.zsh' fix this"
    else
      remove-symlink zsh/zshrc.d/9999-starship-prompt.zsh
    fi
    ;;
  *)
    warning "uninstall starship: unable to determine user shell, or user shell is unknown. Remember to remove any initialization manually added to shell config"
    ;;
  esac
  remove-symlink starship/starship.toml
  remove-dir config starship
  return 0
}
