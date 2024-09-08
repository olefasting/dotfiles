#!/usr/bin/env bash

set -Eeuo pipefail

function error_handler() {
    echo "exiting..."
}

trap 'error_handler $LINENO $?' ERR

source "$PWD/project.metadata"

project_name_versioned="${PROJECT__name:?no PROJECT__name set in project.metadata file}"
[[ -n "$PROJECT__version" ]] && project_name_versioned=" $PROJECT__version"
module_folder_name="modules"
module_metadata_filename="module.metadata"
module_install_filename="module.install.sh"

tab_literal=" "
export current_indent=0

install_targets=("${INSTALL_TARGETS[@]:-all}")
force_install="${FORCE_INSTALL:-0}"
[[ "$force_install" != true ]] && [[ "$force_install" != 1 ]] && force_install=0

function array_contains() {
  local value="$1"
  local array=("\$$2")
  [[ " ${array[*]} " =~ [[:space:]]${value}[[:space:]] ]]
}

function increase_indent() {
    local increment=${1:-1}
    current_indent=$(( current_indent + $increment ))
}

function decrease_indent() {
    local decrement=${1:-1}
    current_indent=$(( current_indent - $decrement ))
}

function reset_indent() {
    current_indent=0
}

function indent_echo() {
    local indent=""
    for i in $(seq 1 $current_indent); do
        indent="$indent$tab_literal"
    done
    echo "$indent$@"
}

function check_and_install_module() {
    local module_path="$1"
    [[ ! -e "$module_path" ]] && echo "invalid module path '$module_path'" >&2 && exit 1
    local install_targets=("${INSTALL_TARGETS[@]:-all}")
    local should_install=false
    if [[ -e "$module_path/$module_metadata_filename" ]] && [[ -f "$module_path/$module_metadata_filename" ]]; then
        unset MODULE__name
        MODULE__targets=(all)
        source "$module_path/$module_metadata_filename"
        local module_name="${MODULE__name?no MODULE__name set in metadata file}"
        if [[ ! -e "$module_path/$module_install_filename" ]]; then
            echo "[WRN] no $module_install_filename in module folder '$module_path'. Skipping folder" >&2
            return 0
        else
            [[ -z "$MODULE__targets" ]] && MODULE__targets=(all)
            for target in $install_targets; do
                [[ "$target" =~ ^all$ ]] && should_install=true && break
            done
            for target in $MODULE__targets; do
                [[ "$target" =~ ^all$ ]] && should_install=true && break
                for itarget in $install_targets; do
                    [[ -n "$target" ]] && [[ -n "$itarget" ]] && [[ "$target" == "$itarget" ]] && should_install=true && break
                done
                [[ "$should_install" == true ]] && break
            done
        fi
        if [[ "$should_install" != true ]]; then
            indent_echo "skipping module $module_name ($module_path)"
        else
            indent_echo "installing module '$module_name' ($module_path)"
            source "$module_path/$module_install_filename"
        fi
    fi
}

reset_indent

indent_echo "$project_name_versioned install"

if [[ $force_install != true ]]; then
    for module_path in "$PWD/$module_folder_name"/*; do
        [[ ! -e "$module_path" ]] && echo "invalid module path '$module_path'" >&2 && exit 1
        if [[ -e "$module_path/$module_metadata_filename" ]] && [[ -f "$module_path/$module_metadata_filename" ]]; then
            unset MODULE__name
            unset MODULE__dependencies
            source "$module_path/$module_metadata_filename"
            if [[ -z "$MODULE__name" ]]; then
                echo "[WRN] invalid $module_metadata_filename file in module folder '$module_path'. Skipping folder" >&2
            else
                module_dependencies=("$MODULE__dependencies[@]")
                if (( ${#module_dependencies[@]} > 0 )); then
                    indent_echo "checking dependencies for module '$MODULE__name'"
                    for dependency in "$MODULE__dependencies"; do
                        if [[ ! -e "$(which "$dependency")" ]]; then
                            echo "[ERR] dependency '$dependency' is not met, please install it or set 'FORCE_INSTALL' to '1'"
                            exit 1
                        fi
                    done
                fi
            fi
        fi
    done
fi

for module_path in "$PWD/$module_folder_name"/*; do
    reset_indent
    check_and_install_module "$module_path"
done

reset_indent

indent_echo "install successful"

unset current_indent
