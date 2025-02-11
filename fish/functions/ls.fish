function ls --description 'alias ls=eza -al'
    command eza -al --color=always --group-directories-first --icons $argv
end
