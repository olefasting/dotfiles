function ll --wraps='eza -l' --description 'alias ll=eza -l'
    command eza -l --color=always --group-directories-first --icons $argv
end
