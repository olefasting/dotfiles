if [ "$LOGGING_SH_SOURCED" == "1" ]; then return; fi
LOGGING_SH_SOURCED=1

LOG_PFX_DEBUG="[DBG] "
LOG_PFX_INFO=""
LOG_PFX_WARNING="[WRN] "
LOG_PFX_ERROR="[ERR] "

LOG_SEVERITY_NONE=0
LOG_SEVERITY_DEBUG=1
LOG_SEVERITY_INFO=2
LOG_SEVERITY_WARNING=3
LOG_SEVERITY_ERROR=4

LOG_SEVERITY_DEFAULT="$LOG_SEVERITY_INFO"

[ -z "$DEBUG" ] && DEBUG=0

if [ "$DEBUG" = "1" ]; then
  VERBOSITY="$LOG_SEVERITY_DEBUG"
else
  DEBUG=0
fi

[ -z "$SILENT" ] && SILENT=0

if [ "$SILENT" = "1" ]; then
  if [ "$DEBUG" = "1" ]; then
    SILENT=0
  else
    VERBOSITY=0
  fi
fi

[ -z "$VERBOSITY" ] && VERBOSITY="$LOG_SEVERITY_DEFAULT"

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
    $LOG_SEVERITY_DEBUG)
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
  local _severity="$1"
  local _type=""
  case "$_severity" in
    $LOG_SEVERITY_NONE)
      _type="none"
      ;;
    $LOG_SEVERITY_DEBUG)
      _type="debug"
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

function debug() {
  fmtout "$LOG_SEVERITY_DEBUG" "$@"
}

function log() {
  info "$@"
}

