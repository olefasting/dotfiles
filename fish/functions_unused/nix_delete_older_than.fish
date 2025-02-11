function nix_delete_older_than --wraps 'nix-collect-garbage --delete-older-than' --description 'Collect everything over a specified age as garbage'
  eval_sudo "nix-collect-garbage --delete-older-than $argv"
end
