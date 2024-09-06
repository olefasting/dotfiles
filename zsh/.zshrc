# export TERM='xterm-256color'
export EDITOR='vim'
export VISUAL='vim'

autoload -U colors && colors
PS1="%{$fg[green]%}[%{$reset_color%} %{$fg[blue]%}%1~%{$reset_color%} %{$fg[green]%}]%{$reset_color%}$%b "
setopt autocd
setopt interactive_comments

export HISTSIZE=268435456
export SAVEHIST="$HISTSIZE"
export HISTFILE="$ZDOTDIR/.zsh_history"
setopt INC_APPEND_HISTORY

bindkey '^R' history-incremental-search-backward

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

bindkey -v
export KEYTIMEOUT=1

asdf_dir="$HOME/.asdf"
if [ -e "$asdf_dir" ] && [ -f "$asdf_dir/asdf.sh" ]; then
        . "$asdf_dir/asdf.sh"

        fpath=(${ASDF_DIR}/completions $fpath)
        autoload -Uz compinit && compinit
fi
unset asdf_dir

zmodload zsh/mapfile

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"


alias ll="ls -la --color=always"

function genrandom() {
        local key_len="$1"
        [ -z "$key_len" ] && key_len=32
        echo $(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9@#%\$\+\*\?\^\=\!\<\>\:\-' | fold -w "$key_len" | head -n 1)
        unset key_len
}

[ -e "$(which kubectl)" ] && kubectl completion zsh > "${fpath[1]}/_kubectl"

eval "$(starship init zsh)"
