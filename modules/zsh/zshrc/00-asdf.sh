if [[ -e "$HOME/.asdf" ]]; then
    if [[ -e "$HOME/.asdf/asdf.sh" ]]; then
        source "$HOME/.asdf/asdf.sh"
        fpath=(${ASDF_DIR}/completions $fpath)
        autoload -Uz compinit && compinit
    fi
    [[ -e "$HOME/.asdf/plugins/golang/set-env.zsh" ]] && source "$HOME/.asdf/plugins/golang/set-env.zsh"
fi
