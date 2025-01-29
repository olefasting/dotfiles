#!/usr/bin/env bash

set -e

LOG_PFX_DEBUG="[DBG]=(1)> "
LOG_PFX_TRACE="[TRC]=(2)> "
LOG_PFX_INFO="[INF]=(3)> "
LOG_PFX_WARNING="[WRN]=(4)> "
LOG_PFX_ERROR="[ERR]=(5)> "

LOG_SEVERITY_NONE=0
LOG_SEVERITY_DEBUG=1
LOG_SEVERITY_TRACE=2
LOG_SEVERITY_INFO=3
LOG_SEVERITY_WARNING=4
LOG_SEVERITY_ERROR=5

LOG_SEVERITY_DEFAULT="$LOG_SEVERITY_INFO"

[ -z "$DEBUG" ] && DEBUG=0

if [ "$DEBUG" == "1" ]; then
  VERBOSITY="$LOG_SEVERITY_DEBUG"
else
  DEBUG=0
fi

[ -z "$VERBOSITY" ] && VERBOSITY="$LOG_SEVERITY_DEFAULT"
[ "$DO_BACKUP" != "1" ] && DO_BACKUP=0

if [ "$VERBOSITY" -lt 0 ]; then 
  VERBOSITY="$LOG_SEVERITY_NONE"
elif [ "$VERBOSITY" -gt "$LOG_SEVERITY_ERROR" ]; then
  VERBOSITY="$LOG_SEVERITY_ERROR"
fi

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

function to_msg_type() {
  local _severity="$1"
  local _type=""
  case "$_severity" in
    $LOG_SEVERITY_NONE)
      _type="none"
      ;;
    $LOG_SEVERITY_DEBUG)
      _type="debug"
      ;;
    $LOG_SEVERITY_TRACE)
      _type="trace"
      ;;
    $LOG_SEVERITY_INFO)
      _type="info"
      ;;
    $LOG_SEVERITY_WARNING)
      _type="warning"
      ;;
    *)
      _type="error"
      ;;
  esac
  echo "$_type"
  unset _type
  unset _severity
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
	info "symlink '$_path1' -> '$_path2'"
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

info "installing to user ${USER}'s home directory ($HOME)"

if [ "$DEBUG" == "1" ]; then
  info "DEBUG     = '1' (on)"
else
  info "DEBUG     = '$DEBUG' (off)"
fi

info "VERBOSITY = '$VERBOSITY' ($(to_msg_type $VERBOSITY))"

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

info "installation completed successfully!"
