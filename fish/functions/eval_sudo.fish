function eval_sudo --description "Prepend sudo to a command if the current user is not root"
  if fish_is_root_user
    eval $argv
  else
    eval "sudo $argv"
  end
end
