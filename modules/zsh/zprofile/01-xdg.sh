export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export XDG_DATA_DIRS="$XDG_DATA_DIRS:$XDG_DATA_HOME"
export XDG_CONFIG_DIRS="$XDG_CONFIG_DIRS:$XDG_CONFIG_HOME"

[ -e "$XDG_CONFIG_HOME" ] || mkdir -p "$XDG_CONFIG_HOME"
[ -e "$XDG_CACHE_HOME" ] || mkdir -p "$XDG_CACHE_HOME"
[ -e "$XDG_DATA_HOME" ] || mkdir -p "$XDG_DATA_HOME"
[ -e "$XDG_STATE_HOME" ] || mkdir -p "$XDG_STATE_HOME"
