# export TERM='xterm-256color'
export EDITOR='vim'
export VISUAL='vim'

function genrandom() {
        local key_len="$1"
        [ -z "$key_len" ] && key_len=32
        echo $(export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w "$key_len" | head -n 1)
        unset key_len
}

alias ll="ls -la --color=always"

# zsh
zmodload zsh/mapfile
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"

[ -n "$(which kubectl)" ] && kubectl completion zsh > "${fpath[1]}/_kubectl"

# asdf
asdf_dir="$HOME/.asdf"
if [ -e "$asdf_dir" ] && [ -f "$asdf_dir/asdf.sh" ]; then
        . "$asdf_dir/asdf.sh"

        fpath=(${ASDF_DIR}/completions $fpath)
        autoload -Uz compinit && compinit
fi
unset asdf_dir

# starship
eval "$(starship init zsh)"
