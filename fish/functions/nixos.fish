function nixos:delete_generations --wraps='nix-env -p /nix/var/nix/profiles/system --delete-generations' --description 'This deletes all old generations except for a specified number of generations'
  eval_sudo "nix-env -p /nix/var/nix/profiles/system --delete-generations $argv"
end

function nixos:delete_older_than --wraps 'nix-collect-garbage --delete-older-than' --description 'Collect everything over a specified age as garbage'
  eval_sudo "nix-collect-garbage --delete-older-than $argv"
end
