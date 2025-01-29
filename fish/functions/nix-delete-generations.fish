function nix-delete-generations --wraps='sudo nix-env -p /nix/var/nix/profiles/system --delete-generations' --description 'alias nix-delete-generations=sudo nix-env -p /nix/var/nix/profiles/system --delete-generations'
  sudo nix-env -p /nix/var/nix/profiles/system --delete-generations $argv
        
end
