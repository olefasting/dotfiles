#!/usr/bin/env bash

set -e

DOTFILES_DIR=$(readlink -f "$0" | xargs -0 dirname)
export DOTFILES_DIR

cd "$DOTFILES_DIR"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

[[ -e "$XDG_CONFIG_HOME" ]] || mkdir -p "$XDG_CONFIG_HOME"
[[ -e "$XDG_DATA_HOME" ]] || mkdir -p "$XDG_DATA_HOME"
[[ -e "$XDG_CACHE_HOME" ]] || mkdir -p "$XDG_CACHE_HOME"

DOTFILES_DATA_DIR="${DOTFILES_DATA_DIR:-$XDG_DATA_HOME/dotfiles}"
export DOTFILES_DATA_DIR

[[ -e "$XDG_DATA_HOME/dotfiles" ]] || mkdir -p "$XDG_DATA_HOME/dotfiles"

source "$DOTFILES_DIR/scripts/logging.sh"
source "$DOTFILES_DIR/scripts/install_helpers.sh"

SKIP_INSTALLED="${SKIP_INSTALLED:-0}"
FORCE_UNINSTALL="${FORCE_UNINSTALL:-0}"
UNINSTALL_PKGS="${UNINSTALL_PKGS:-0}"
DEBUG="${DEBUG:-0}"

DOTFILES_SHELL="${DOTFILES_SHELL:-$(basename $SHELL)}"
export DOTFILES_SHELL

info "installing to user ${USER}'s home directory ($HOME)"

if [[ "$SKIP_INSTALLED" == "1" ]]; then
  info "SKIP_INSTALLED is '1' (on)"
else
  info "SKIP_INSTALLED is '$SKIP_INSTALLED' (off)"
fi
if [[ "$FORCE_UNINSTALL" == "1" ]]; then
  info "FORCE_UNINSTALL is '1' (on)"
else
  info "FORCE_UNINSTALL is '$FORCE_UNINSTALL' (off)"
fi
if [[ "$UNINSTALL_PKGS" == "1" ]]; then
  info "UNINSTALL_PKGS is '1' (on)"
else
  info "UNINSTALL_PKGS is '$UNINSTALL_PKGS' (off)"
fi
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

_PACMAN_INSTALL_ARGS="-Syq --noconfirm --noprogressbar"
_PACMAN_UNINSTALL_ARGS="-Rncs --noconfirm --noprogressbar"

if [[ ! -e "$XDG_DATA_HOME/dotfiles" ]]; then
  info "no dotfiles data directory found, creating it now"
  create-dir data dotfiles
fi

install git kde-plasma ufw mpv asdf ghostty zig zls zellij zsh starship sheldon nvim helix hyprland zed biome tree-sitter flowise

info "all installation tasks completed successfully!"

unset _PACMAN_INSTALL_ARGS
unset _PACMAN_UNINSTALL_ARGS
