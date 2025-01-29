#!/usr/bin/env bash

set -e

function create_symlink() {
  local _pfx=""
  local _path1="$1"
  local _path2="$2"
  if [ -n "$3" ] && [ "$1" == sudo ]; then
    _pfx="sudo "
    _path1="$2"
    _path2="$3"
	elif [ -z "$1" ] || [ -z "$2" ]; then 
		echo "ERROR: create_symlink require two parameters"
		return 1
	fi
	if [ ! -e "$_path1" ]; then
		echo "ERROR: path 1 '$_path1' does not exist"
		return 1
	fi
	echo "creating symlink from '$_path1' to '$_path2'..."
  if [ -e "$_path2" ]; then
    if [ "$NO_BACKUPS" -eq 1 ] || [ -L "$_path2" ]; then
      local _cmd="${_pfx}rm -rf $_path2"
      $($_cmd)
    else
      if [ -e "$_path2.old" ]; then
        local _cmd="${_pfx}rm -rf ${_path2}.old" 
        $($_cmd)
      fi

      local _cmd="${_pfx}mv $_path2 ${_path2}.old"
      $($_cmd)
    fi
  fi

  local _cmd="${_pfx}ln -s $_path1 $_path2"
  $($_cmd)

  unset _cmd

  unset _pfx
  unset _path1
  unset _path2

	return 0
}

[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"

[ -e "$XDG_CONFIG_HOME" ] && mkdir -p "$XDG_CONFIG_HOME"

echo "symlinking dotfiles to users home directory"

[ "$NO_BACKUPS" -eq 1 ] && echo "WARNING: backups are turned off (NO_BACKUP is 1)"

create_symlink sudo "$PWD/nixos/configuration.nix" "/etc/nixos/configuration.nix"
create_symlink "$PWD/alacritty" "$XDG_CONFIG_HOME/alacritty"
create_symlink "$PWD/tmux/tmux.conf" "$HOME/.tmux.conf"
create_symlink "$PWD/nvim" "$XDG_CONFIG_HOME/nvim"

echo "symlinking complete!"
