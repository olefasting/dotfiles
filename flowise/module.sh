function __install_module() {
  require node
  npm install -g flowise langchainhub
  create-dir config flowise
  create-symlink sudo flowise/flowise.service /usr/lib/systemd/user/flowise.service
  systemctl --user enable --now flowise
}

function __uninstall_module() {
  systemctl --user disable --now flowise
  npm remove -g flowise langchainhub
  remove-symlink sudo flowise/flowise.service /usr/lib/systemd/user/flowise.service
  remove-dir config flowise
}
