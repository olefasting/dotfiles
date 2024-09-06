#!/usr/bin/env bash

set -Eeuo pipefail

trap 'error_handler $LINENO $?' ERR

function error_handler() {
  error "ERROR: line $1: $2"
}

function install_module() {
    [[ -z "$1" ]] && echo "install_module requires a modpath as the first argument" >&2 && return 1

    local modpath="$1"

    [[ ! -e "$modpath" ]] && echo "invalid module path '$modpath'" >&2 && return 1
    if [[ -e "$modpath/module" ]] && [[ -f "$modpath/module" ]]; then
        source "$PWD/modules/common/metadata-clear"
        source "$modpath/module"

        [[ -z "$MODULE__name" ]] && echo "invalid module file '$modpath'" >&2 && return 1
        echo " module '$MODULE__name' installing"

        [[ -e "$modpath/install" ]] && source "$modpath/install"
        if [[ -e "$modpath/install.d" ]]; then
            for filepath in "$modpath"/install.d/[0-9][0-9]-*; do
                source "$filepath"
            done
        fi
    fi
}

echo "environment setup and dotfiles install"

for modpath in "$PWD"/modules/*; do
    install_module "$modpath"
done

echo "install finished"
