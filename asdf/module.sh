function __install_module() {
  if ! has-pkg asdf-vm; then
    eval "yay $_PACMAN_INSTALL_ARGS asdf-vm"
  fi
  create-dir data asdf
  set +e
  asdf plugin add deno https://github.com/asdf-community/asdf-deno.git
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf plugin add zig https://github.com/asdf-community/asdf-zig.git
  asdf plugin add zls https://github.com/dochang/asdf-zls.git
  asdf install
  set -e
  return 0
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]] && has-pkg asdf-vm; then
    eval "yay $_PACMAN_UNINSTALL_ARGS asdf-vm"
  fi
  remove-dir data asdf
  return 0
}
