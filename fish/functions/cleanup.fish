function cleanup --description 'alias cleanup=sudo pacman -Rns (pacman -Qtdq)'
	command sudo pacman -Rns (pacman -Qtdq) $argv
end
