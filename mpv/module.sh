function __install_module() {
  if ! has-pkg ffmpeg; then
    eval "yay $_PACMAN_INSTALL_ARGS ffmpeg python-ffsubsync"
  fi
  if ! has-pkg alass; then
    eval "yay $_PACMAN_INSTALL_ARGS alass"
  fi
  if ! has-pkg mpv; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS mpv"
  fi
  create-dir config mpv
  create-symlink mpv/shaders
  create-symlink mpv/scripts
  create-symlink mpv/script-opts
  if [[ ! -e "$DOTFILES_DIR/mpv/scripts/autosubsync" ]]; then
    git clone 'https://github.com/Ajatt-Tools/autosubsync-mpv' "$DOTFILES_DIR/mpv/scripts/autosubsync"
  elif [[ ! -e "$DOTFILES_DIR/mpv/scripts/autosubsync/.git" ]]; then
    local _prevpath="$PWD"
    cd "$DOTFILES_DIR/mpv/scripts/autosubsync"
    git pull
    cd "$_prevpath"
    unset _prevpath
  fi
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg mpv; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS mpv"
  fi
  remove-symlink mpv/shaders
  remove-symlink mpv/scripts
  remove-symlink mpv/script-opts
  remove-dir config mpv
  if [[ -e "$DOTFILES_DIR/mpv/scripts/autosubsync" ]]; then
    rm -rf "$DOTFILES_DIR/mpv/scripts/autosubsync"
  fi
}
