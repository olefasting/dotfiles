DOTFILES_DATA_DIR="${DOTFILES_DATA_DIR:-$XDG_DATA_HOME/dotfiles}"

function has-pkg() {
  if [[ "$#" == "0" ]]; then
    error "has-pkg requires a package name as its first parameter"
    return 1
  fi
  if ! yay -Q "$1" >/dev/null 2>&1; then
    return 1
  fi
  unset _pkg
  return 0
}

function has-cmd() {
  local _cmd
  if [[ -z "$1" ]]; then
    error "has-pkg requires a package name as its first parameter"
    return 1
  fi
  if ! command -v "$1" >/dev/null 2>&1; then
    return 1
  fi
  unset _cmd
  return 0
}

function is-installed() {
  if [[ -z "$1" ]]; then
    error "is-installed: requires a module name as its first parameter"
    return 1
  fi
  local _name="$1"
  if ! grep ^"${_name}"$ "$DOTFILES_DATA_DIR/installed" >/dev/null 2>&1; then
    return 1
  fi
  return 0
}

function is-absolute() {
  if [[ -z "$1" ]]; then
    error "is-absolute: requires a path as first argument ($*)"
    return 1
  fi
  local _path="$1"
  if [[ "$_path" != /* ]]; then
    return 1
  fi
  return 0
}

function prefix-path() {
  if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    error "prefix-path: invalid arguments ($*)"
    return 1
  fi
  local _type _path
  _type="$1"
  _path="$2"
  case "$_type" in
  config)
    _path="${XDG_CONFIG_HOME}/${_path}"
    ;;
  data)
    _path="${XDG_DATA_HOME}/${_path}"
    ;;
  cache)
    _path="${XDG_CACHE_HOME}/${_path}"
    ;;
  *)
    error "prefix-path: invalid directory type '$_type' for '$_path'"
    return 1
    ;;
  esac
  echo "$_path" >&1
  return 0
}

function is-prefix-type() {
  if [[ -z "$1" ]]; then
    error "is-prefix-type: requires a prefix type as its first argument"
    return 1
  fi
  case "$_type" in
  config | data | cache) ;;
  *)
    return 1
    ;;
  esac
  return 0
}

function create-dir() {
  if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    error "create-dir: invalid arguments (@*)"
    return 1
  fi
  local _pfx _type _path
  _pfx=""
  _type="$1"
  _path="$2"
  if [[ "$1" == sudo ]]; then
    _pfx="sudo "
    _type="$2"
    _path="$3"
  fi
  if ! is-prefix-type "$_type"; then
    error "create-dir: invalid prefix type '$_type'"
    return 1
  fi
  local _fullpath
  _fullpath="$(prefix-path "$_type" "$_path")"
  debug "create-dir: attempting to create a $_type directory at '$_fullpath'"
  eval "${_pfx}mkdir -p $_fullpath"
  return 0
}

function remove-dir() {
  if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    error "remove-dir: invalid arguments (@*)"
    return 1
  fi
  local _pfx _type _path
  _pfx=""
  _type="$1"
  _path="$2"
  if [[ "$1" == sudo ]]; then
    _pfx="sudo "
    _type="$2"
    _path="$3"
  fi
  if ! is-prefix-type "$_type"; then
    error "remove-dir: invalid prefix type '$_type'"
    return 1
  fi
  local _fullpath
  if ! is-absolute "$_name"; then
    _fullpath="$(prefix-path "$_type" "$_name")"
  fi
  if [[ ! -L "$_fullpath" ]]; then
    error "remove-dir: called for '$_name' but no symlink was found at '$_fullpath'"
    return 1
  fi
  eval "${_pfx}rm -rf $_fullpath"
  return 0
}

function create-symlink() {
  local _pfx=""
  local _path1="$1"
  local _path2="$2"
  if [[ "$1" == sudo ]] && [[ -n "$2" ]]; then
    _pfx="sudo "
    _path1="$2"
    _path2="$3"
  elif [[ -z "$1" ]]; then
    error "create-symlink: requires a relative file path parameter"
    return 1
  fi
  if is-absolute "$_path1"; then
    error "create-symlink: path to source can't be an absolute path ($_path1)"
    return 1
  fi
  [[ -n "$_path2" ]] || _path2="$_path1"
  local _fullpath1="${DOTFILES_DIR}/${_path1}"
  local _fullpath2="$_path2"
  if ! is-absolute "$_fullpath2"; then
    _fullpath2="$(prefix-path config "$_path2")"
  fi
  if [[ ! -e "$_fullpath1" ]]; then
    error "create-symlink: path '$_fullpath1' does not exist"
    return 1
  fi
  info "create-symlink: create '$_fullpath2' -> '$_fullpath1'"
  if [[ -e "$_fullpath2" ]]; then
    if [[ -e "$_fullpath2.old" ]]; then
      eval "${_pfx}rm -rf ${_fullpath2}.old"
    fi
  fi
  if [[ -L "$_fullpath2" ]]; then
    eval "${_pfx}rm -f $_fullpath2"
  elif [[ -e "$_fullpath2" ]]; then
    eval "${_pfx}mv $_fullpath2 ${_fullpath2}.old"
  fi
  eval "${_pfx}ln -s $_fullpath1 $_fullpath2 >/dev/null"
  debug "create-symlink: created symlink '$_fullpath2' -> '$_fullpath1'"
  return 0
}

function remove-symlink() {
  if [[ -z "$1" ]]; then
    error "remove-symlink: requires a symlink name as a parameter"
    return 1
  fi
  local _pfx _name _path
  _pfx=""
  _name="$1"
  if [[ "$1" == sudo ]]; then
    _pfx="sudo"
    _name="$2"
  fi
  _path="$_name"
  if ! is-absolute "$_name"; then
    _path="$(prefix-path config "$_name")"
  fi
  if [[ ! -L "$_path" ]]; then
    error "remove-symlink: called for '$_name' but no symlink was found at '$_path'"
    return 1
  fi
  eval "${_pfx}rm $_path"
  return 0
}

function source-module() {
  if [[ -z "$1" ]]; then
    error "source-module: requires a module name as its first parameter"
    return 1
  fi
  if [[ ! -e "$DOTFILES_DIR/$_name" ]] || [[ -f "$DOTFILES_DIR/$_name" ]]; then
    error "source-module: called for '$_name' but no module named '$_name' was found in '$DOTFILES_DIR'"
    return 1
  elif [[ ! -e "$DOTFILES_DIR/$_name/module.sh" ]]; then
    error "source-module: called for '$_name' but the module directory does not contain a module.sh file"
    return 1
  fi
  unset-module-declarations
  source "$DOTFILES_DIR/$_name/module.sh"
}

function unset-module-declarations() {
  unset -f __install_module
  unset -f __uninstall_module
}

function require() {
  if [[ -z "$1" ]]; then
    warning "require: requires at least one module name as its parameter"
    return 1
  fi
  local _name
  for _name in "$@"; do
    if is-installed "$_name" && [[ "$SKIP_INSTALLED" == "1" ]]; then
      continue
    fi
    install "$_name"
  done
  return 0
}

function install() {
  if [[ -z "$1" ]]; then
    warning "install: requires at least one module name as its parameter"
    return 1
  fi
  local _name
  for _name in "$@"; do
    if [[ ! -d "$DOTFILES_DIR/$_name" ]]; then
      error "install: called for '$_name' but the module could not be found in '$DOTFILES_DIR'"
      return 1
    fi
    if is-installed "$_name"; then
      warning "install: called for '$_name', but '$_name' is already installed"
      [[ "$SKIP_INSTALLED" == "1" ]] && continue
    fi
    debug "attempting install for '${_name}'"
    source-module "$_name"
    __install_module
    unset-module-declarations
    is-installed "$_name" || echo "$_name" >>"$DOTFILES_DATA_DIR/installed"
  done
  debug "install for '$_name' completed successfully"
  return 0
}

function uninstall() {
  if [[ -z "$1" ]]; then
    warning "uninstall: requires at least one module name as its parameter"
    return 1
  fi
  for _name in "$@"; do
    if ! is-installed "$_name"; then
      warning "uninstall: called for '$_name', but '$_name' is not installed"
      [[ "$FORCE_UNINSTALL" == "1" ]] && continue
    fi
    source-module "$_name"
    __uninstall_module
    unset-module-declarations
    local _filecontent
    _filecontent="$(sed /^"$_name"$/d "$DOTFILES_DATA_DIR/installed")"
    echo "$_filecontent" >"$DOTFILES_DATA_DIR/installed"
  done
  debug "uninstall: completed for '$_name'"
  return 0
}
