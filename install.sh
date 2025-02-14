#!/usr/bin/env bash

set -e

DOTFILES_DIR=$(readlink -f "$0" | xargs -0 dirname)

cd "$DOTFILES_DIR"

export DOTFILES_DIR

source "${PWD}/scripts/logging.sh"
source "${PWD}/scripts/install_helpers.sh"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

[[ ! -e "$XDG_CONFIG_HOME" ]] || mkdir -p "$XDG_CONFIG_HOME"
[[ ! -e "$XDG_DATA_HOME" ]] || mkdir -p "$XDG_DATA_HOME"
[[ ! -e "$XDG_CACHE_HOME" ]] || mkdir -p "$XDG_CACHE_HOME"

BACKUP="${BACKUP:-0}"

function install_asdf() {
  if not command -v asdf >& /dev/null &&
    not command -v asdf-vm >& /dev/null; then
    debug "install_asdf asdf binary not found, attempting install"
    yay --noconfirm --noprogressbar -Syq asdf-vm
  fi
  mkdir -p "$XDG_DATA_HOME/asdf"
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf plugin add zig https://github.com/asdf-community/asdf-zig.git
  asdf install
  return 0
}

function install_alacritty() {
  if not command -v alacritty >& /dev/null; then
    debug "install_alacritty alacritty binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq alacritty
  fi
  mkdir -p "$XDG_CONFIG_HOME/alacritty"
  create_symlink "$PWD/alacritty/alacritty.toml" "$XDG_CONFIG_HOME/alacritty/alacritty.toml"
  create_symlink "$PWD/alacritty/catppuccin-mocha.toml" "$XDG_CONFIG_HOME/alacritty/catppuccin-mocha.toml"
  if [[ ! -e "$(which alacritty)" ]]; then
    eval "$_paccmd -Syq alacritty"
  fi
  return 0
}

function install_ghostty() {
  if not command -v ghostty >& /dev/null; then
    debug "install_ghostty ghostty binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq ghostty
  fi
  mkdir -p "$XDG_CONFIG_HOME/ghostty"
  create_symlink "$PWD/ghostty/config" "${XDG_CONFIG_HOME}/ghostty/config"
  return 0
}

function install_git() {
  if not command -v git >& /dev/null; then
    debug "install_git git binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq git
  fi
  create_symlink "$PWD/git/gitconfig" "$XDG_CONFIG_HOME/.gitconfig"
  return 0
}

function install_helix() {
  if not command -v hx >& /dev/null &&
    not command -v helix >& /dev/null; then
    debug "install_helix hx/helix binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq helix
  fi
  mkdir -p "${XDG_CONFIG_HOME}/helix"
  mkdir -p "${XDG_DATA_HOME}/helix"
  create_symlink "$PWD/helix/config.toml" "$XDG_CONFIG_HOME/helix/config.toml"
  create_symlink "$PWD/helix/languages.toml" "$XDG_CONFIG_HOME/helix/languages.toml"
  create_symlink "$PWD/helix/themes" "$XDG_CONFIG_HOME/helix/themes"
  return 0
}

function install_kakoune() {
  if not command -v kak >& /dev/null &&
    not command -v kakoune >& /dev/null; then
    debug "install_kakoune kak/kakoune binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq kakoune kakoune-lsp
  fi
  mkdir -p "${XDG_CONFIG_HOME}/kak"
  mkdir -p "${XDG_DATA_HOME}/kak"
  create_symlink "$PWD/kakoune/kakrc" "$XDG_CONFIG_HOME/kak/kakrc"
  create_symlink "$PWD/kakoune/kak-lsp.toml" "$XDG_CONFIG_HOME/kak/kak-lsp.toml"
  create_symlink "$PWD/kakoune/autoload" "$XDG_CONFIG_HOME/kak/autoload"
  create_symlink "$PWD/kakoune/colors" "$XDG_CONFIG_HOME/kak/colors"
  return 0
}

function install_neovim() {
  if not command -v nvim >& /dev/null &&
    not command -v neovim >& /dev/null; then
    debug "install_neovim nvim/neovim binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq neovim neovim-lspconfig
  fi
  mkdir -p "${XDG_CONFIG_HOME}/nvim"
  mkdir -p "${XDG_DATA_HOME}/nvim"
  create_symlink "$PWD/nvim/.luarc.json" "$XDG_CONFIG_HOME/nvim/.luarc.json"
  create_symlink "$PWD/nvim/init.lua" "$XDG_CONFIG_HOME/nvim/init.lua"
  create_symlink "$PWD/nvim/lazy-lock.json" "$XDG_CONFIG_HOME/nvim/lazy-lock.json"
  create_symlink "$PWD/nvim/lua" "$XDG_CONFIG_HOME/nvim/lua"
  return 0
}

function install_rustup() {
  if not command -v rustup >& /dev/null; then
    debug "install_kakoune kak/kakoune binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq rustup
  fi
  return 0
}

function install_sheldon() {
  if not command -v sheldon >& /dev/null; then
    debug "install_sheldon sheldon binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq sheldon
  fi
  local _shell="$1"
  [[ -z "$1" ]] && _shell=$(basename "$SHELL")
  local _filepath="$PWD/sheldon/plugins.${_shell}.toml"
  if [[ ! -e "$_filepath" ]]; then
    error "install_sheldon the config file for shell '$_shell' could not be found ($_filepath)"
    return 1
  fi
  mkdir -p "${XDG_CONFIG_HOME}/sheldon"
  mkdir -p "${XDG_DATA_HOME}/sheldon"
  create_symlink "${_filepath}" "${XDG_CONFIG_HOME}/sheldon/plugins.toml"
  return 0
}

function install_tree_sitter() {
  if not command -v tree-sitter >& /dev/null; then
    debug "install_tree_sitter tree-sitter binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq tree-sitter
  fi
  mkdir -p "${XDG_CONFIG_HOME}/tree-sitter"
  create_symlink "$PWD/tree-sitter/config.json" "$XDG_CONFIG_HOME/tree-sitter/config.json"
  return 0
}

function install_zed() {
  if not command -v zed >& /dev/null &&
    not command -v zeditor >& /dev/null; then
    debug "install_zed zed/zeditor binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq zed
  fi
  mkdir -p "${XDG_CONFIG_HOME}/zed"
  mkdir -p "${XDG_DATA_HOME}/zed"
  create_symlink "$PWD/zed/settings.json" "$XDG_CONFIG_HOME/zed/settings.json"
  return 0
}

function install_zsh() {
  if not command -v zsh >& /dev/null; then
    debug "install_zsh zsh binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq zsh
  fi
  mkdir -p "${XDG_CONFIG_HOME}/zsh"
  mkdir -p "${XDG_DATA_HOME}/zsh"
  create_symlink "$PWD/zsh/zshenv" "$HOME/.zshenv"
  create_symlink "$PWD/zsh/zshrc" "$XDG_CONFIG_HOME/zsh/.zshrc"
  create_symlink "$PWD/zsh/autoload" "$XDG_CONFIG_HOME/zsh/autoload"
  return 0
}

function install_zellij() {
  if not command -v zellij >& /dev/null; then
    debug "install_zellij zellij binary not found, attempting install"
    sudo pacman --noconfirm --noprogressbar -Syq zellij
  fi
  mkdir -p "${XDG_CONFIG_HOME}/zellij"
  mkdir -p "${XDG_DATA_HOME}/zellij"
  create_symlink "$PWD/zellij/config.kdl" "$XDG_CONFIG_HOME/zellij/config.kdl"
  create_symlink "$PWD/zellij/layouts" "$XDG_CONFIG_HOME/zellij/layouts"
  create_symlink "$PWD/zellij/plugins" "$XDG_CONFIG_HOME/zellij/plugins"
  create_symlink "$PWD/zellij/themes" "$XDG_CONFIG_HOME/zellij/themes"
  return 0
}

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

install_ghostty
install_zellij
install_zsh
install_sheldon zsh
install_asdf
install_helix
install_zed
install_tree_sitter

info "all installation tasks completed successfully!"
