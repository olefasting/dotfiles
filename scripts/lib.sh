if [ "$LIB_SH_SOURCED" == "1" ]; then return; fi
LIB_SH_SOURCED=1

unset LIB_INITIATED

BASE_MODULES=( logging )

function load_modules() {
  for _module in "$@"; do
    source "$PWD/scripts/${_module}.sh"
  done
}
load_modules "${BASE_MODULES[@]}"
if [ -n "${SCRIPT_DEPENDENCIES}" ]; then
  load_modules "${SCRIPT_DEPENDENCIES[@]}"
fi

export LIB_INITIATED=1
