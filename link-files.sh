#!/usr/bin/env bash

set -e

function backup_and_link() {
	if [ -z "$1" ] || [ -z "$2" ]; then 
		echo "ERROR: backup_and_link require two parameters"
		return 1
	fi
	local _path1="$1"
	local _path2="$2"
	if [ ! -e "$_path1" ]; then
		echo "ERROR: path 1 '$_path1' does not exist"
		return 1
	fi
	echo "creating symlink from '$_path1' to '$_path2'..."
	[ -e "${_path2}.old" ] && rm -rf "${_path2}.old"
	mv "$_path2" "${_path2}.old"
	ln -s "$_path1" "$_path2"
	echo "success!"
	return 0
}

[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"

[ -e "$XDG_CONFIG_HOME" ] && mkdir -p "$XDG_CONFIG_HOME"

backup_and_link "$PWD/alacritty" "$XDG_CONFIG_HOME/alacritty"
backup_and_link "$PWD/tmux/tmux.conf" "$HOME/.tmux.conf"
backup_and_link "$PWD/nvim" "$XDG_CONFIG_HOME/nvim"
