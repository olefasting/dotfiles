[ -e "$GOBIN" ] && PATH="$PATH:$GOBIN"
_pbinpath="$(dirname "$GOROOT")/packages/bin"
[ -e "$_pbinpath" ] && export PATH="$PATH:$_pbinpath"
unset _pbinpath
