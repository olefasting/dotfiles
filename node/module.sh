function __install_module() {
  require asdf
  set +e
  asdf install nodejs latest
  set -e
}

function __uninstall_module() {
  if [[ "$UNINSTALL_PKGS" == "1" ]]; then
    set +e
    asdf uninstall nodejs latest
    set -e
  fi
}
