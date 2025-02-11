function gitpkg --description 'alias gitpkg=pacman -Q | grep -i "\-git" | wc -l'
	command pacman -Q | grep -i "\-git" | wc -l
end
