#!/usr/bin/env bash

set -e

DOTFILES_DIR=$(readlink -f "$0" | xargs -0 dirname)

cd "$DOTFILES_DIR"

export DOTFILES_DIR

dotfiles_installed=()

source "$DOTFILES_DIR/scripts/logging.sh"
source "$DOTFILES_DIR/scripts/install_helpers.sh"
source "$DOTFILES_DIR/scripts/install_tasks.sh"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

[[ ! -e "$XDG_CONFIG_HOME" ]] || mkdir -p "$XDG_CONFIG_HOME"
[[ ! -e "$XDG_DATA_HOME" ]] || mkdir -p "$XDG_DATA_HOME"
[[ ! -e "$XDG_CACHE_HOME" ]] || mkdir -p "$XDG_CACHE_HOME"

DEBUG="${DEBUG:-0}"
BACKUP="${BACKUP:-0}"

info "installing to user ${USER}'s home directory ($HOME)"

if [[ "$DEBUG" == "1" ]]; then
  info "DEBUG     = '1' (on)"
else
  info "DEBUG     = '$DEBUG' (off)"
fi

install git asdf ghostty zellij starship zsh sheldon helix zed tree-sitter

info "all installation tasks completed successfully!"
