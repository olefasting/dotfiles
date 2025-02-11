function l. --description "alias l.=eza -a | grep -e '^\.'"
    command eza -a | grep -e '^\.' $argv
end
