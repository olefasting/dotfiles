function big --description 'alias big=expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl'
	command expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl
end
