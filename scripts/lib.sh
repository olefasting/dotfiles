if [ "$LIB_SH_SOURCED" == "1" ]; then return; fi
LIB_SH_SOURCED=1

unset LIB_INITIATED

[ -z "$LIB_HOME_DIR" ] && LIB_HOME_DIR="./"

[ -z "$LIB_MODULES" ] && LIB_MODULES=()

_modules=( logging "${LIB_MODULES[@]}" )

[ -z "$LIB_LOADED_MODULES" ] && LIB_LOADED_MODULES=()

for _name in "${_modules[@]}"; do
  if [[ ${LIB_LOADED_MODULES[@]} =~ $_name ]]; then
    echo "warning: attempting to load module '$_name' but it is already loaded" >&2
  else
    _path="${LIB_HOME_DIR}/${_name}.sh"
    if [ ! -e "$_path" ]; then
      echo "fatal: the module '$_name' could not be found in the specified library home dir '${LIB_HOME_DIR}'" >&2
      return 1
    else
      source "$_path"
      LIB_LOADED_MODULES+=( "$_name" )
    fi
    unset _path
  fi
done

export LIB_INITIATED=1
