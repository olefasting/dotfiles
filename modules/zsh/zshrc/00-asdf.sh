if [[ -e "$HOME/.asdf" ]] && [[ -e "$HOME/.asdf/asdf.sh" ]]; then
        source "$HOME/.asdf/asdf.sh"
        fpath=(${ASDF_DIR}/completions $fpath)
        autoload -Uz compinit && compinit
fi
