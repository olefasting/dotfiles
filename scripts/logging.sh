if [[ "$LOGGING_SH_SOURCED" == "1" ]]; then return; fi
LOGGING_SH_SOURCED=1

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

if [[ "$DEBUG" == "1" ]]; then
  VERBOSITY="$LOG_SEVERITY_DEBUG"
else
  DEBUG=0
fi

SILENT="${SILENT:-0}"

if [[ "$SILENT" == "1" ]]; then
  if [[ "$DEBUG" == "1" ]]; then
    SILENT=0
  else
    VERBOSITY=0
  fi
fi

VERBOSITY="${VERBOSITY:-$LOG_SEVERITY_DEFAULT}"

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
      echo "${LOG_PFX_ERROR}to_pfx was provided an invalid message severity ($_severity)" 1>&2
      return 1
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
  if [[ "$#" == "0" ]]; then
    _severity="$LOG_SEVERITY_DEFAULT"
  else
    shift
  fi
  local _msg="$@"
  echo "$(to_pfx $_severity)$_msg"
  unset _msg
  unset _severity
  return 0
}

[[ "$SILENT" == "1" ]] && VERBOSITY=0

case "$VERBOSITY" in
  "$LOG_SEVERITY_DEBUG")
    function debug() { logfmt "$LOG_SEVERITY_DEBUG" "$@"; }
    function info() { logfmt "$LOG_SEVERITY_INFO" "$@"; }
    function warn() { logfmt "$LOG_SEVERITY_WARNING" "$@"; }
    function error() { logfmt "$LOG_SEVERITY_ERROR" "$@" >&2; }
    ;;
  "$LOG_SEVERITY_INFO")
    function debug() { true; }
    function info() { logfmt "$LOG_SEVERITY_INFO" "$@"; }
    function warn() { logfmt "$LOG_SEVERITY_WARNING" "$@"; }
    function error() { logfmt "$LOG_SEVERITY_ERROR" "$@" >&2; }
    ;;
  "$LOG_SEVERITY_WARNING")
    function debug() { true; }
    function info() { true; }
    function warn() { logfmt "$LOG_SEVERITY_WARNING" "$@"; }
    function error() { logfmt "$LOG_SEVERITY_ERROR" "$@" >&2; }
    ;;
  "$LOG_SEVERITY_ERROR")
    function debug() { true; }
    function info() { true; }
    function warn() { true; }
    function error() { logfmt "$LOG_SEVERITY_ERROR" "$@" >&2; }
    ;;
  *)
    function debug() { true; }
    function info() { true; }
    function warn() { true; }
    function error() { true; }
    ;;
esac

alias err='error'
alias warning='warn'
alias log='info'
