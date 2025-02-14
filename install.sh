#!/usr/bin/env bash

set -e

cd "$(readlink -f $0 | xargs -0 dirname)"

export DOTFILES_DIR="$PWD"

source "${PWD}/scripts/logging.sh"
source "${PWD}/scripts/install_helpers.sh"
source "${PWD}/scripts/install_tasks.sh"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

[[ ! -e "$XDG_CONFIG_HOME" ]] || mkdir -p "$XDG_CONFIG_HOME"
[[ ! -e "$XDG_DATA_HOME" ]] || mkdir -p "$XDG_DATA_HOME"
[[ ! -e "$XDG_CACHE_HOME" ]] || mkdir -p "$XDG_CACHE_HOME"

BACKUP="${BACKUP:-0}"

info "installing to user ${USER}'s home directory ($HOME)"

if [[ "$DEBUG" == "1" ]]; then
  info "DEBUG     = '1' (on)"
else
  info "DEBUG     = '$DEBUG' (off)"
fi

info "VERBOSITY = '$VERBOSITY' ($(to_msg_type $VERBOSITY))"

if [[ "$BACKUP" == "1" ]]; then
  info "BACKUP    = '1' (on)"
else
  info "BACKUP    = '$BACKUP' (off)"
fi

install_editor "${EDITOR:-nvim}"
if [[ "$VISUAL" != "${EDITOR:-nvim}" ]]; then
  [[ -n "$VISUAL" ]] || install_editor "$VISUAL"
fi

install_tree_sitter
install_asdf
install_alacritty
install_zsh
install_zellij

info "all installation tasks completed successfully!"
