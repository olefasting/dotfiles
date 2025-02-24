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

DOTFILES_SHELL="${DOTFILES_SHELL:-$(basename $SHELL)}"
case "$DOTFILES_SHELL" in
zsh)
  debug "shell integration set to 'zsh', either via the DOTFILES_SHELL variable, or the current user shell ($SHELL), if it wasn't set"
  ;;
*)
  debug "the shell '$DOTFILES_SHELL' is not valid for integration, please set DOTFILES_SHELL to a valid shell (currently only zsh is supported)"
  unset DOTFILES_SHELL
  ;;
esac

export DOTFILES_SHELL

info "installing to user ${USER}'s home directory ($HOME)"

if [[ -n "$DOTFILES_SHELL" ]]; then
  info "DOTFILES_SHELL is '$DOTFILES_SHELL'"
else
  info "DOTFILES_SHELL is 'none'"
fi
if [[ "$DEBUG" == "1" ]]; then
  info "DEBUG is '1' (on)"
else
  info "DEBUG is '$DEBUG' (off)"
fi

[[ ! -e "$XDG_DATA_HOME/dotfiles" ]] && mkdir -p "$XDG_DATA_HOME/dotfiles"

add-dir data dotfiles

install git ufw mpv asdf alacritty ghostty zig zls zellij zsh starship sheldon nvim helix hyprland zed biome tree-sitter

info "all installation tasks completed successfully!"
