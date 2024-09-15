[[ -e "$HOME/.asdf/plugins/golang/set-env.zsh" ]] && source "$HOME/.asdf/plugins/golang/set-env.zsh"
[[ -e "$GOBIN" ]] && PATH="$PATH:$GOBIN"
_pbinpath="$(dirname "$GOROOT")/packages/bin"
[[ -e "$_pbinpath" ]] && export PATH="$PATH:$_pbinpath"
unset _pbinpath

[[ -e "$HOME/.encore" ]] && export ENCORE_INSTALL="$HOME/.encore"
[[ -e "$ENCORE_INSTALL/bin" ]] && export PATH="$ENCORE_INSTALL/bin:$PATH"

[[ -e "$HOME/.surrealdb" ]] && export PATH="$PATH:$HOME/.surrealdb"
