#!/usr/bin/env bash

set -e

cd "$(readlink -f $0 | xargs -0 dirname)"

source "${PWD}/scripts/logging.sh"

function create_symlink() {
  local _pfx=""
  local _path1="$1"
  local _path2="$2"
  if [ -n "$3" ] && [ "$1" == sudo ]; then
    _pfx="sudo "
    _path1="$2"
    _path2="$3"
  elif [ -z "$1" ] || [ -z "$2" ]; then 
    error "create_symlink require two parameters"
    return 1
  fi
  if [ ! -e "$_path1" ]; then
     error "path '$_path1' does not exist"
     return 1
  fi
  info "symlink '$_path1' -> '$_path2'"
  local _folder="$(dirname $_path2)"
  if [ ! -e "$_folder" ]; then
    if [ -f "$_folder" ]; then
      error "destination folder path exists but is not a directory (path '$_folder' must be empty or point to a directory)"
      return 1
    fi
    local _cmd="${_pfx}mkdir -p $_folder"
    eval "$_cmd"
  fi
  if [ ! -L "$_path2" ] && [ "$BACKUP" == "1" ]; then
    if [ -e "$_path2.old" ]; then
      local _cmd="${_pfx}rm -rf ${_path2}.old" 
      eval "$_cmd"
    fi
    local _cmd="${_pfx}mv $_path2 ${_path2}.old"
    eval "$_cmd"
  elif [ -d "$_path2" ]; then
    local _cmd="${_pfx}rm -rf $_path2"
    eval "$_cmd" 
  elif [ -e "$_path2" ]; then
    local _cmd="${_pfx}rm -f $_path2"
    eval "$_cmd"
  fi

  local _cmd="${_pfx}ln -s $_path1 $_path2"
  eval "$_cmd"

  unset _cmd
  unset _folder
  unset _pfx
  unset _path1
  unset _path2

  return 0
}

[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"

[ -e "$XDG_CONFIG_HOME" ] && mkdir -p "$XDG_CONFIG_HOME"

[ -z "$BACKUP" ] && BACKUP=0

info "installing to user ${USER}'s home directory ($HOME)"

if [ "$DEBUG" = "1" ]; then
  info "DEBUG     = '1' (on)"
else
  info "DEBUG     = '$DEBUG' (off)"
fi

info "VERBOSITY = '$VERBOSITY' ($(to_msg_type $VERBOSITY))"

if [ "$BACKUP" = "1" ]; then
  info "BACKUP    = '1' (on)"
else
  info "BACKUP    = '$BACKUP' (off)"
fi

# create_symlink sudo "$PWD/nixos/configuration.nix" "/etc/nixos/configuration.nix"
# create_symlink "$PWD/fish" "$XDG_CONFIG_HOME/fish"
create_symlink "$PWD/zsh/zshenv" "$HOME/.zshenv"
create_symlink "$PWD/zsh/zshrc" "$XDG_CONFIG_HOME/zsh/.zshrc"
create_symlink "$PWD/zsh/.p10k.zsh" "$XDG_CONFIG_HOME/zsh/.p10k.zsh"
create_symlink "$PWD/alacritty" "$XDG_CONFIG_HOME/alacritty"
create_symlink "$PWD/zellij" "$XDG_CONFIG_HOME/zellij"
# create_symlink "$PWD/nvim" "$XDG_CONFIG_HOME/nvim"
create_symlink "$PWD/helix" "$XDG_CONFIG_HOME/helix"
create_symlink "$PWD/tree-sitter/config.json" "$XDG_CONFIG_HOME/tree-sitter/config.json"
# create_symlink "$PWD/starship/starship.toml" "$XDG_CONFIG_HOME/starship.toml"
# create_symlink "$PWD/foot/foot.ini" "$XDG_CONFIG_HOME/foot/foot.ini"
create_symlink "$PWD/zfxtop/config.ini" "$XDG_CONFIG_HOME/zfxtop/config.ini"

info "installation completed successfully!"
