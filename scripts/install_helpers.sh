if [ "$INSTALL_HELPERS_SH_SOURCED" == "1" ]; then return; fi
INSTALL_HELPERS_SH_SOURCED=1

function create_dirs() {
  if [[ "$#" -lt 2 ]]; then
    error "create_dirs must be called with a name as its first parameter, followed by one or more directory type parameters"
    return 1
  fi

  local _name="$1"
  shift  
  
  for _type in $@; do
    local _parent=""
    case "$_type" in
      config)
      _parent="${XDG_CONFIG_HOME}"
      ;;
      data)
      _parent="${XDG_DATA_HOME}"
      ;;
      cache)
      _parent="${XDG_CACHE_HOME}"
      ;;
      *)
      error "create_dirs was called with an invalid type parameter '$_type'"
      return 1
      ;;
    esac

    local _path="${_parent}/${_name}"
    if [[ -e "$_path" ]]; then
      if [[ -L "$_path" ]]; then
        debug "create_dirs deleting old symlink"
        rm "$_path"
      elif [[ "$BACKUP" == "1" ]]; then
        if [[ -e "${_path}.old" ]]; then
          debug "create_dirs deleting old backup"
          rm -rf "${_path}.old"
        fi
        debug "create_dirs creating backup"
        mv "$_path" "${_path}.old"
      else
        debug "create_dirs deleting existing"
        rm -rf "$_path"
      fi
    fi

    info "creating $_type dir '$_path'"
    mkdir -p "$_path"

    unset _path
    unset _parent
  done
  
  unset _name
  unset _types

  return 0
}

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
  if [[ ! -L "$_path2" ]] && [[ "$BACKUP" == "1" ]]; then
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
