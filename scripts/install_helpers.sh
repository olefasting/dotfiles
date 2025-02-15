if [ "$INSTALL_HELPERS_SH_SOURCED" == "1" ]; then return; fi
INSTALL_HELPERS_SH_SOURCED=1

function create_symlink() {
  local _pfx=""
  local _path1="$1"
  local _path2="$2"
  if [[ -n "$3" ]] && [[ "$1" == sudo ]]; then
    _pfx="sudo "
    _path1="$2"
    _path2="$3"
  elif [[ -z "$1" ]] || [[ -z "$2" ]]; then 
    error "create_symlink require two parameters"
    return 1
  fi
  if [[ ! -e "$_path1" ]]; then
     error "path '$_path1' does not exist"
     return 1
  fi
  info "creating symlink '$_path2' -> '$_path1'"
  local _folder="$(dirname $_path2)"
  if [[ ! -e "$_folder" ]]; then
    if [[ -f "$_folder" ]]; then
      error "create_symlink destination folder path exists but is not a directory (path '$_folder' must be empty or point to a directory)"
      return 1
    fi
    local _cmd="${_pfx}mkdir -p $_folder"
    eval "$_cmd"
  fi
  if [[ ! -L "$_path2" ]]; then
    if [[ -e "$_path2.old" ]]; then
      local _cmd="${_pfx}rm -rf ${_path2}.old" 
      eval "$_cmd"
    fi
    local _cmd="${_pfx}mv $_path2 ${_path2}.old"
    eval "$_cmd"
  elif [[ -d "$_path2" ]]; then
    local _cmd="${_pfx}rm -rf $_path2"
    eval "$_cmd" 
  elif [[ -L "$_path2" ]] || [[ -e "$_path2" ]]; then
    local _cmd="${_pfx}rm -f $_path2"
    eval "$_cmd"
  fi

  local _cmd="${_pfx}ln -s $_path1 $_path2"
  eval "$_cmd"

  debug "created symlink '$_path2' -> '$_path1'"

  unset _cmd
  unset _folder
  unset _pfx
  unset _path1
  unset _path2

  return 0
}
