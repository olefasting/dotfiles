function __install_module() {
  create-dir config pipewire
  create-symlink pipewire/pipewire.conf
  create-symlink pipewire/pipewire.conf.d
  return 0
}

function __uninstall_module() {
  remove-symlink pipewire/pipewire.conf
  remove-symlink pipewire/pipewire.conf.d
  remove-dir config pipewire
  return 0
}
