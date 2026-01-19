export LANGUAGE = "${LANGUAGE:-en_US}"
# export LC_ALL = (unset)
# export LC_CTYPE = (unset)
export LC_NUMERIC = "${LC_NUMERIC:-nb_NO.UTF-8}"
export LC_COLLATE = "${LC_COLLATE:-en_US.UTF-8}"
export LC_TIME = "${LC_TIME:-nb_NO.UTF-8}"
export LC_MESSAGES = "${LC_MESSAGES:-en_US.UTF-8}"
export LC_MONETARY = "${LC_MONETARY:-nb_NO.UTF-8}"
export LC_ADDRESS = "${LC_ADDRESS:-nb_NO.UTF-8}"
export LC_IDENTIFICATION = "${LC_IDENTIFICATION:-en_US.UTF-8}"
export LC_MEASUREMENT = "${LC_MEASUREMENT:-nb_NO.UTF-8}"
export LC_PAPER = "${LC_PAPER:-en_US.UTF-8}"
export LC_TELEPHONE = "${LC_TELEPHONE:-nb_NO.UTF-8}"
export LC_NAME = "${LC_NAME:-nb_NO.UTF-8}"
export LANG = "${LANG:-en_US.UTF-8}"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-~/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-~/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-~/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-~/.local/state}"
export XDG_RUNTIME_HOME="${XDG_RUNTIME_HOME:?no 'XDG_RUNTIME_HOME' specified for user}"

export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"

export GHOSTTY_RESOURCE_DIR="${GHOSTTY_RESOURCE_DIR:-$XDG_CONFIG_HOME/ghostty/res}"

export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
