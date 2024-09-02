#!/usr/bin/env bash

set -e

export XDG_CONFIG_HOME="$HOME/.config"
[ -e "$XDG_CONFIG_HOME" ] || mkdir "$XDG_CONFIG_HOME"

cp "$PWD/zsh/.zprofile" "$HOME/"
cp "$PWD/zsh/.zshenv" "$HOME/"
cp "$PWD/zsh/.zshrc" "$HOME/"

[ -e "$XDG_CONFIG_HOME/zellij" ] || mkdir "$XDG_CONFIG_HOME/zellij"

cp "$PWD/zellij/config.kdl" "$XDG_CONFIG_HOME/zellij/"
