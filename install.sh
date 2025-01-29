#!/usr/bin/env bash

set -e

LOG_PFX_DEBUG="DEBUG: "
LOG_PFX_TRACE="TRACE: "
LOG_PFX_INFO="INFO: "
LOG_PFX_WARNING="WARNING: "
LOG_PFX_ERROR="ERROR: "

LOG_SEVERITY_DEBUG=1
LOG_SEVERITY_TRACE=2
LOG_SEVERITY_INFO=3
LOG_SEVERITY_WARNING=4
LOG_SEVERITY_ERROR=5

LOG_SEVERITY_DEFAULT="$LOG_SEVERITY_INFO"

LOG_ERROR_DEFAULT="an unspecified error occured"

[ -z "$VERBOSITY" ] && VERBOSITY="$LOG_SEVERITY_DEFAULT"

function to_pfx() {
  local _severity="$1"
  if [ -z "$1" ]; then
    echo "${LOG_PFX_ERROR}to_pfx must be called with at least one argument" 1>&2
    return 1
  fi
  local _pfx=""
  case "$_severity" in
    $LOG_SEVERITY_ERROR)
      _pfx="$LOG_PFX_ERROR"
      ;;
    $LOG_SEVERITY_WARNING)
      _pfx="$LOG_PFX_WARNING"
      ;;
    $LOG_SEVERITY_INFO)
      _pfx="$LOG_PFX_INFO"
      ;;
    $LOG_SEVERITY_TRACE)
      _pfx="$LOG_PFX_TRACE"
      ;;
    $LOG_SEVERITY_DEBUG)
      _pfx="$LOG_PFX_DEBUG"
      ;;
    *)
      echo "${LOG_PFX_ERROR}to_pfx was provided an invalid message severity ($_severity)" 1>&2
      return 1
  esac
  echo "$_pfx"
  return 0
}

function fmtout() {
  local _severity="$1"
  if [ "$#" -eq 0 ]; then
    echo "${LOG_PFX_ERROR}fmtout must be called with at least one argument" 1>&2
    return 1
  elif [ "$#" -eq 1 ]; then 
    _severity="$LOG_SEVERITY_DEFAULT"
  else
    shift
  fi
  if [ "$_severity" -ge "$VERBOSITY" ]; then
    local _msg="$(to_pfx $_severity)"
    _msg+="$@"
    if [ "$_severity" -ge "$LOG_SEVERITY_WARNING" ]; then
      echo "$_msg" 1>&2
    else
      echo "$_msg" 1>&1
    fi
    unset _msg
  fi
  unset _severity
  return 0
}

function error() {
  fmtout "$LOG_SEVERITY_ERROR" "$@"
}

function warn() {
  fmtout "$LOG_SEVERITY_WARNING" "$@"
}

function info() {
  fmtout "$LOG_SEVERITY_INFO" "$@"
}

function trace() {
  fmtout "$LOG_SEVERITY_TRACE" "$@"
}

function debug() {
  fmtout "$LOG_SEVERITY_DEBUG" "$@"
}

function create_symlink() {
  local _pfx=""
  local _path1="$1"
  local _path2="$2"
  if [ -n "$3" ] && [ "$1" == sudo ]; then
    _pfx="sudo "
    _path1="$2"
    _path2="$3"
	elif [ -z "$1" ] || [ -z "$2" ]; then 
		errout "create_symlink require two parameters"
		return 1
	fi
	if [ ! -e "$_path1" ]; then
		errout "path '$_path1' does not exist"
		return 1
	fi
	info "creating symlink from '$_path1' to '$_path2'..."
  local _folder="$(dirname $_path2)"
  if [ ! -e "$_folder" ]; then
    if [ -f "$_folder" ]; then
      errout "destination folder path exists but is not a directory (path '$_folder' must be empty or point to a directory)"
      return 1
    fi
    local _cmd="${_pfx}mkdir -p $_folder"
    $($_cmd)
  fi
  if [ -e "$_path2" ]; then
    if [ ! -L "$_path2" ] && [ "$DO_BACKUP" == "1" ]; then
      if [ -e "$_path2.old" ]; then
        local _cmd="${_pfx}rm -rf ${_path2}.old" 
        $($_cmd)
      fi 
      local _cmd="${_pfx}mv $_path2 ${_path2}.old"
      $($_cmd)
    else
      local _cmd="${_pfx}rm -f $_path2"
      $($_cmd)
    fi
  fi

  local _cmd="${_pfx}ln -s $_path1 $_path2"
  $($_cmd)

  unset _cmd
  unset _folder
  unset _pfx
  unset _path1
  unset _path2

	return 0
}

[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"

[ -e "$XDG_CONFIG_HOME" ] && mkdir -p "$XDG_CONFIG_HOME"

info "symlinking dotfiles to users home directory"

info "VERBOSITY = '$VERBOSITY'"

[ "$DO_BACKUP" != "1" ] && DO_BACKUP=0
if [ $DO_BACKUP == "1" ]; then
  info "DO_BACKUP = '1' (on)"
else
  info "DO_BACKUP = '$DO_BACKUP' (off)"
fi

create_symlink sudo "$PWD/nixos/configuration.nix" "/etc/nixos/configuration.nix"
create_symlink "$PWD/fish" "$XDG_CONFIG_HOME/fish"
create_symlink "$PWD/alacritty" "$XDG_CONFIG_HOME/alacritty"
create_symlink "$PWD/tmux/tmux.conf" "$HOME/.tmux.conf"
create_symlink "$PWD/nvim" "$XDG_CONFIG_HOME/nvim"
create_symlink "$PWD/tree-sitter/config.json" "$XDG_CONFIG_HOME/tree-sitter/config.json"

info "symlinking complete!"
