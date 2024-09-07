PS1="%{$fg[green]%}[%{$reset_color%} %{$fg[blue]%}%1~%{$reset_color%} %{$fg[green]%}]%{$reset_color%}$%b "

setopt autocd
setopt interactive_comments

export HISTSIZE=268435456
export HISTFILE="$XDG_STATE_HOME/zsh/history"

[ -d "$XDG_CACHE_HOME/zsh" ] || mkdir -p "$XDG_CACHE_HOME/zsh"
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
compinit -d "${XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION}"

setopt INC_APPEND_HISTORY

bindkey '^R' history-incremental-search-backward

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

_comp_options+=(globdots)

bindkey -v
export KEYTIMEOUT=1

zmodload zsh/mapfile

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
