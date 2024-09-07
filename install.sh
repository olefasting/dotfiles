#!/usr/bin/env bash

PROJECT__name="olefasting/dotfiles"
PROJECT__tab=" "
PROJECT__module_folder_name="modules"
PROJECT__metadata_filename="module.metadata"
PROJECT__install_filename="module.install.sh"

export PROJECT__current_indent=0

set -Eeuo pipefail

trap 'error_handler $LINENO $?' ERR

function error_handler() {
    echo "exiting..."
}

function increase_indent() {
    local increment=${1:-1}
    local result=$(( $PROJECT__current_indent + $increment ))
    PROJECT__current_indent=$(( PROJECT__current_indent + $increment ))
}

function decrease_indent() {
    local decrement=${1:-1}
    local result=$(( $PROJECT__current_indent - $decrement ))
    PROJECT__current_indent=$(( PROJECT__current_indent - $decrement ))
}

function indent_echo() {
    local indent=""
    for i in $(seq 1 $PROJECT__current_indent); do
        indent="$indent$PROJECT__tab"
    done
    echo "$indent$@"
}

echo "starting $PROJECT__name environment setup and dotfiles install"

for modpath in "$PWD/$PROJECT__module_folder_name"/*; do
    [[ ! -e "$modpath" ]] && echo "invalid module path '$modpath'" >&2 && exit 1
    if [[ -e "$modpath/$PROJECT__metadata_filename" ]] && [[ -f "$modpath/$PROJECT__metadata_filename" ]]; then
        unset MODULE__name
        source "$modpath/$PROJECT__metadata_filename"
        if [[ -z "$MODULE__name" ]]; then
            echo "[WRN] invalid $PROJECT__metadata_filename file in module folder '$modpath'. Skipping folder" >&2
        else
            if [[ ! -e "$modpath/$PROJECT__install_filename" ]]; then
                echo "[WRN] no $PROJECT__install_filename in module folder '$modpath'. Skipping folder" >&2
            else
                indent_echo "module '$MODULE__name' ($modpath) is installing"
                source "$modpath/$PROJECT__install_filename"
            fi
        fi
    fi
done

PROJECT__current_indent=0

indent_echo "the $PROJECT__name install procedure finished successfully"

unset PROJECT__current_indent
