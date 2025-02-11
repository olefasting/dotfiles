function psmem10 --description 'alias psmem10=ps auxf | sort -nr -k 4 | head -10'
    command alias psmem=ps auxf | sort -nr -k 4 | head -10
end
