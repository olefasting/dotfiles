function nix_delete_generations --wraps='nix-env -p /nix/var/nix/profiles/system --delete-generations' --description 'This deletes all old generations except for a specified number of generations'
  eval_sudo "nix-env -p /nix/var/nix/profiles/system --delete-generations $argv"
end

