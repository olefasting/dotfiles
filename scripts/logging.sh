LOG_PFX_DEBUG="[DBG] "
LOG_PFX_INFO="[INF] "
LOG_PFX_WARNING="[WRN] "
LOG_PFX_ERROR="[ERR] "

LOG_SEVERITY_NONE=0
LOG_SEVERITY_DEBUG=1
LOG_SEVERITY_INFO=2
LOG_SEVERITY_WARNING=3
LOG_SEVERITY_ERROR=4

LOG_SEVERITY_DEFAULT="$LOG_SEVERITY_INFO"

DEBUG="${DEBUG:-0}"

function logpfx() {
  local _severity="$1"
  if [ -z "$1" ]; then
    echo "${LOG_PFX_ERROR}logpfx must be called with at least one argument" 1>&2
    return 1
  fi
  local _pfx=""
  case "$_severity" in
  "$LOG_SEVERITY_ERROR")
    _pfx="$LOG_PFX_ERROR"
    ;;
  "$LOG_SEVERITY_WARNING")
    _pfx="$LOG_PFX_WARNING"
    ;;
  "$LOG_SEVERITY_INFO")
    _pfx="$LOG_PFX_INFO"
    ;;
  "$LOG_SEVERITY_DEBUG")
    _pfx="$LOG_PFX_DEBUG"
    ;;
  *)
    echo "${LOG_PFX_ERROR}logpfx was provided an invalid message severity ($_severity)" 1>&2
    return 1
    ;;
  esac
  echo "$_pfx"
  unset _pfx
  unset _severity
  return 0
}

function to_msg_type() {
  case "$1" in
  "$LOG_SEVERITY_DEBUG")
    echo "debug"
    ;;
  "$LOG_SEVERITY_INFO")
    echo "info"
    ;;
  "$LOG_SEVERITY_WARNING")
    echo "warning"
    ;;
  *)
    echo "none"
    ;;
  esac
  return 0
}

function logfmt() {
  local _severity="$1"
  [[ -z "$1" ]] || shift
  echo "$(logpfx $_severity)$@"
  unset _severity
  return 0
}

function debug() {
  [[ "$DEBUG" == "1" ]] || return 0
  logfmt "$LOG_SEVERITY_DEBUG" "$@"
  return 0
}

function info() {
  logfmt "$LOG_SEVERITY_INFO" "$@"
  return 0
}

function warning() {
  logfmt "$LOG_SEVERITY_WARNING" "$@"
  return 0
}

function error() {
  logfmt "$LOG_SEVERITY_ERROR" "$@" >&2
  return 0
}

function log() {
  info "$@"
  return 0
}

function err() {
  error "$@"
  return 0
}

function warn() {
  warning "$@"
  return 0
}
