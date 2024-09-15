if [[ ! $__ZSHENV_SOURCED ]]; then
    [[ -e "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv" || source "$HOME/.zshenv"
fi
