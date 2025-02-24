DOTFILES_DATA_DIR="${DOTFILES_DATA_DIR:-$XDG_DATA_HOME/dotfiles}"

function has-pkg() {
  if [[ "$#" == "0" ]]; then
    error "has-pkg requires a package name or a package name as its first parameter"
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
  if [[ "$#" == "0" ]]; then
    error "has-pkg requires a package name or a package name as its first parameter"
    return 1
  fi
  if ! command -v "$1" >/dev/null 2>&1; then
    return 1
  fi
  unset _cmd
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

function prefix-dirpath() {
  if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    error "prefix-dirpath: invalid arguments ($*)"
    return 1
  fi
  local _type _name
  _type="$1"
  _name="$2"
  case "$_type" in
  config | conf | cfg)
    _path="${XDG_CONFIG_HOME}/${_path}"
    ;;
  data)
    _path="${XDG_DATA_HOME}/${_path}"
    ;;
  cache)
    _path="${XDG_CACHE_HOME}/${_path}"
    ;;
  *)
    error "prefix-dirpath: invalid directory type '$_type'"
    return 1
    ;;
  esac
  echo "$_path" >&1
  return 0
}

function add-dir() {
  if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    error "add-dir: invalid arguments (@*)"
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
  local _is_in_file
  _is_in_file=0
  if grep ^";$_type;$_path" "$DOTFILES_DATA_DIR/directories" >/dev/null 2>&1; then
    _is_in_file=1
  fi
  local _fullpath
  _fullpath="$(prefix-dirpath "$_type" "$_path")"
  if [[ "$_is_in_file" == 1 ]] && [[ -d "$_fullpath" ]]; then
    debug "add-dir: attempting to add a dir that is already added and created"
    return 0
  fi
  debug "add-dir: attempting to create a $_type directory at '$_fullpath'"
  eval "${_pfx}mkdir -p $_fullpath"
  if [[ "$_is_in_file" != 1 ]]; then
    if [[ ! -e "$DOTFILES_DATA_DIR/directories" ]]; then
      echo "TYPE;PATH" >"$DOTFILES_DATA_DIR/directories"
    fi
    echo ";$_type;$_path" >>"$DOTFILES_DATA_DIR/directories"
  fi
  return 0
}

function add-symlink() {
  local _pfx=""
  local _path1="$1"
  local _path2="$2"
  if [[ "$1" == sudo ]] && [[ -n "$2" ]]; then
    _pfx="sudo "
    _path1="$2"
    _path2="$3"
  elif [[ "$1" != sudo ]]; then
    _pfx=""
    _path1="$1"
    _path2="$2"
  elif [[ -z "$1" ]]; then
    error "add-symlink: requires a relative file path parameter"
    return 1
  fi
  local _is_in_file
  _is_in_file=0
  if
    grep ^";$_path1;$_path2" "$DOTFILES_DATA_DIR/symlinks" >/dev/null 2>&1
  then
    debug "add-symlink: attempting to create an already existing symlink"
    _is_in_file=1
  fi
  [[ -z "$_path2" ]] && _path2="$_path1"
  if is-absolute "$_path1"; then
    error "add-symlink: path to source cant be an absolute path ($_path1)"
    return 1
  fi
  local _fullpath1="${DOTFILES_DIR}/${_path1}"
  local _fullpath2="$_path2"
  if ! is-absolute "$_fullpath2"; then
    _fullpath2="${XDG_CONFIG_HOME}/${_path2}"
  fi
  if [[ ! -e "$_fullpath1" ]]; then
    error "add-symlink: path '$_fullpath1' does not exist"
    return 1
  fi
  info "creating symlink '$_fullpath2' -> '$_fullpath1'"
  if [[ -e "$_fullpath2" ]]; then
    if [[ -e "$_fullpath2.old" ]]; then
      eval "${_pfx}rm -rf ${_fullpath2}.old"
    fi
    if [[ -L "$_fullpath2" ]]; then
      eval "${_pfx}rm -f $_fullpath2"
    else
      eval "${_pfx}mv $_fullpath2 ${_fullpath2}.old"
    fi
  fi
  eval "${_pfx}ln -s $_fullpath1 $_fullpath2"
  if [[ "$_is_in_file" != 1 ]]; then
    if [[ ! -e "$DOTFILES_DATA_DIR/symlinks" ]]; then
      echo "PATH1;PATH2" >"$DOTFILES_DATA_DIR/symlinks"
    fi
    echo ";$_path1;$_path2" >>"$DOTFILES_DATA_DIR/symlinks"
  fi
  debug "created symlink '$_fullpath2' -> '$_fullpath1'"
  return 0
}
