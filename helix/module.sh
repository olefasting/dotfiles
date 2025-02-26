function __install_module() {
  if ! has-pkg helix && ! has-pkg helix-git; then
    eval "sudo pacman $_PACMAN_INSTALL_ARGS helix"
  fi
  if [ -e /usr/bin/helix ] && [ ! -e /usr/bin/hx ]; then
    sudo ln -s /usr/bin/helix /usr/bin/hx
  elif [ -e /usr/bin/hx ] && [ ! -e /usr/bin/helix ]; then
    sudo ln -s /usr/bin/hx /usr/bin/helix
  fi
  create-dir config helix
  create-dir data helix
  create-symlink helix/config.toml
  create-symlink helix/languages.toml
  create-symlink helix/themes
  hx --grammar fetch
  hx --grammar build
  return 0
}

function __uninstall_module() {
  if ! has-pkg helix; then
    eval "sudo pacman $_PACMAN_UNINSTALL_ARGS helix"
  fi
  if [ -L /usr/bin/hx ]; then
    sudo rm /usr/bin/hx
  elif [ -L /usr/bin/helix ]; then
    sudo rm /usr/bin/helix
  fi
  remove-symlink helix/config.toml
  remove-symlink helix/languages.toml
  remove-symlink helix/themes
  remove-dir data helix
  remove-dir config helix
  return 0
}
