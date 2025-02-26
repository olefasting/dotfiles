function __install_module() {
  if ! has-pkg zsh; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS zsh"
  fi
  create-dir config zsh
  create-dir cache zsh
  create-symlink zsh/zshenv "$HOME/.zshenv"
  create-symlink zsh/zshrc zsh/.zshrc
  create-symlink zsh/autoload
  create-symlink zsh/completions
  create-symlink zsh/functions
  create-symlink zsh/zshenv.d
  create-symlink zsh/zshrc.d
  export DOTFILES_SHELL="zsh"
  sudo chsh -s "$(which zsh)" "$USER"
  return 0
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" ]] && has-pkg zsh; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS zsh"
  fi
  sudo chsh -s "$(which bash)" "$USER"
  export DOTFILES_SHELL="bash"
  remove-symlink zsh/zshenv "$HOME/.zshenv"
  remove-symlink zsh/zshrc zsh/.zshrc
  remove-symlink zsh/autoload
  remove-symlink zsh/completions
  remove-symlink zsh/functions
  remove-symlink zsh/zshenv.d
  remove-symlink zsh/zshrc.d
  remove-dir config zsh
  remove-dir cache zsh
}
