typeset -gx LANGUAGE=en_US:en
typeset -gx LANG=en_US.UTF-8
typeset -gx LC_LANGUAGE=en_US.UTF-8
typeset -gx LC_CTYPE=en_US.UTF-8
typeset -gx LC_NUMERIC=en_US.UTF-8
typeset -gx LC_COLLATE=en_US.UTF-8
typeset -gx LC_TIME=nb_NO.UTF-8
typeset -gx LC_MESSAGES=en_US.UTF-8
typeset -gx LC_MONETARY=en_US.UTF-8
typeset -gx LC_ADDRESS=nb_NO.UTF-8
typeset -gx LC_IDENTIFICATION=nb_NO.UTF-8
typeset -gx LC_MEASUREMENT=nb_NO.UTF-8
typeset -gx LC_PAPER=nb_NO.UTF-8
typeset -gx LC_TELEPHONE=nb_NO.UTF-8
typeset -gx LC_NAME=nb_NO.UTF-8
typeset -gx LC_ALL

typeset -gx XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
typeset -gx XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
typeset -gx XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

typeset -gx EDITOR=hx
typeset -gx VISUAL=zeditor

typeset -gx ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"

typeset -gx ASDF_DATA_DIR="${ASDF_DATA_DIR:-$XDG_DATA_HOME/asdf}"
typeset -gx HELIX_RUNTIME_FOLDER="${HELIX_RUNTIME_FOLDER:-$XDG_DATA_HOME/helix}"

typeset -gx LD_LIBRARY_PATH=/home/oasf/.local/lib/arch-mojo:$LD_LIBRARY_PATH

typeset -gU path=(
  $HOME/{,s}bin(N)
  $HOME/.local/{,s}bin(N)
  /opt/local/{,s}bin(N)
  /usr/local/{,s}bin(N)

  $ASDF_DATA_DIR/shims

  /usr/lib/rustup/bin
  $HOME/.cargo/bin

  $path
)

typeset -gU fpath=(
  $ZDOTDIR/autoload
  $ZDOTDIR/functions
  $ZDOTDIR/completions

  $fpath
)

export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"

[ -e ~/.config/zsh/.zshrc ] && source ~/.config/zsh/.zshrc
