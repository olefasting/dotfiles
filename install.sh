#!/usr/bin/env bash

set -e

export ZDOTDIR="${ZDOTDIR:-$HOME}"

[ -e "$XDG_CONFIG_HOME" ] || mkdir -p "$XDG_CONFIG_HOME"
[ -e "$ZDOTDIR" ] || mkdir -p "$ZDOTDIR"

(( $VERBOSE )) && echo "environment setup and dotfiles install"

(( $VERBOSE )) && echo " ENVIRONMENT_KIND = '$ENVIRONMENT_KIND'"

[ -e "$ZDOTDIR/.zprofile" ] && mv "$ZDOTDIR/.zprofile" "$ZDOTDIR/.zprofile.bak"
[ -e "$ZDOTDIR/.zshrc" ] && mv "$ZDOTDIR/.zshrc" "$ZDOTDIR/.zshrc.bak"
[ -e "$ZDOTDIR/.zshenv" ] && mv "$ZDOTDIR/.zshenv" "$ZDOTDIR/.zshenv.bak"

cp "$PWD/zsh/.zprofile" "$ZDOTDIR/.zprofile"
cp "$PWD/zsh/.zshrc" "$ZDOTDIR/.zshrc"
cp "$PWD/zsh/.zshenv" "$ZDOTDIR/.zshenv"

if [ "$zdotdir" != "$HOME" ]; then
    [ -L "$HOME/.zshenv" ] && rm "$HOME/.zshenv"
    [ -e "$HOME/.zshenv" ] && mv "$HOME/.zshenv" "$HOME/.zshenv.bak"
    ln -s "$ZDOTDIR/.zshenv" "$HOME/.zshenv"
fi

[ -e "$XDG_CONFIG_HOME/zellij" ] || mkdir -p "$XDG_CONFIG_HOME/zellij"

[ -e "$XDG_CONFIG_HOME/zellij/config.kdl" ] && mv "$XDG_CONFIG_HOME/zellij/config.kdl" "$XDG_CONFIG_HOME/zellij/config.kdl.bak"

cp "$PWD/zellij/config.kdl" "$XDG_CONFIG_HOME/zellij/config.kdl"

(( $VERBOSE )) && echo "install finished"
