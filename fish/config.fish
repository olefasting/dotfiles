set -gx LANGUAGE en_US:en
set -gx LANG en_US.UTF-8
set -gx LC_LANGUAGE en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8
set -gx LC_NUMERIC en_US.UTF-8
set -gx LC_COLLATE en_US.UTF-8
set -gx LC_TIME nb_NO.UTF-8
set -gx LC_MESSAGES en_US.UTF-8
set -gx LC_MONETARY en_US.UTF-8
set -gx LC_ADDRESS nb_NO.UTF-8
set -gx LC_IDENTIFICATION nb_NO.UTF-8
set -gx LC_MEASUREMENT nb_NO.UTF-8
set -gx LC_PAPER nb_NO.UTF-8
set -gx LC_TELEPHONE nb_NO.UTF-8
set -gx LC_NAME nb_NO.UTF-8
set -gx LC_ALL en_US.UTF-8

if test -z "$XDG_CONFIG_HOME"
    set -gx XDG_CONFIG_HOME "$HOME/.config"
end

set -gx EDITOR nvim

if status is-interactive
  alias --save l="ls -l"
  alias --save ll="ls -lah"
  alias --save ls="ls --color=tty"

  alias --save nix-delete-generations="sudo nix-env -p /nix/var/nix/profiles/system --delete-generations"
end
