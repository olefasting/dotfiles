function jctl --description 'alias jctl=journalctl -p 3 -xb'
	command journalctl -p 3 -xb $argv
end
