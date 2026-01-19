HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY

source "$ZDOTDIR/antidote/antidote.zsh"
antidote load "$ZDOTDIR/.zsh_plugins.txt"

