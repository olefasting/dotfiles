typeset -gx ZDOTDIR="${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}"

autoload -Uz compinit
compinit

source '/usr/share/zsh-antidote/antidote.zsh'
antidote load "$HOME/.config/zsh/zsh_plugins.txt"

# uncomment for vim keybindings
# bindkey -v

typeset -gx TERM=xterm-ghostty

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -gA key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

typeset -gx TERMINFO="$HOME/.terminfo"

if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi

autoload -Uz compinit colors

setopt sharehistory
setopt promptsubst

compinit
colors

# zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' completer _expand _complete _correct _approximate
# zstyle ':completion:*' format 'Completing %d'
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*' menu select=2

# eval "$(dircolors -b)"

# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# zstyle ':completion:*' menu select-long
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %%s
# zstyle ':completion:*' use-compctl false
# zstyle ':completion:*' verbose true
# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

typeset -gx HISTSIZE=300000
typeset -gx SAVEHIST=300000
typeset -gx HISTFILE="${XDG_CACHE_HOME}/zsh/histfile"
typeset -gx HISTCONTROL=ignoreboth
typeset -gx HISTIGNORE="&:[bf]g:c:clear:history:exit:q:pwd:* --help"

[[ -z "$PROMPT_COMMAND" ]] || PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
typeset -gx PROMPT_COMMAND

LESS_TERMCAP_md="$(
  tput bold 2>/dev/null
  tput setaf 2 2>/dev/null
)"
LESS_TERMCAP_me="$(tput sgr0 2>/dev/null)"
typeset -gx LESS_TERMCAP_md LESS_TERMCAP_me

typeset -gx ENHANCD_FILTER="fzf --height 40%:fzy"

#alias open="xdg-open"
alias make="make -j$(nproc)"
alias ninja="ninja -j$(nproc)"
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short'
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

alias ls="eza --color=always --group-directories-first --icons=always "
alias la="eza -a --color=always --group-directories-first --icons=always "
alias ll="eza -la --color=always --group-directories-first --icons=always "
alias lt="eza -aT --color=always --group-directories-first --icons=always "
alias l.="eza -a --color=always --group-directories-first --icons=always | grep -e '^\.' "
alias ll.="eza -la --color=always --group-directories-first --icons=always | grep -e '^\.' "

alias jctl="journalctl -p 3 -xb"
alias jctlb="journalctl -b -1"

alias yayrm="yay -Rsn "
alias yaysearch="yay -Ss "
alias yayinfo="yay -Sii "

alias pacrm="sudo pacman -Rsn "
alias pacinfo="pacman -Sii "
alias pacrmcc="sudo pacman -Scc"
alias pacunlck="sudo rm /var/lib/pacman/db.lck"
alias pacupdt="sudo pacman -Syu"
alias paccln="sudo pacman -Rsn $(pacman -Qtdq)"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

typeset -gx FZF_BASE="${FZF_BASE:-/usr/share/fzf}"

# this gets reset somewhere between here and the sourcing of .zshenv, so we add the custom ones again
typeset -gU fpath=(
  $ZDOTDIR/autoload
  $ZDOTDIR/functions
  $ZDOTDIR/completions

  $fpath
)
