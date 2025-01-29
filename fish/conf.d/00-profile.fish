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
set -gx LC_ALL

if test -n "$XDG_CONFIG_HOME"
  set -gx XDG_CONFIG_HOME "$HOME/.config"
end

set -gx EDITOR nvim
