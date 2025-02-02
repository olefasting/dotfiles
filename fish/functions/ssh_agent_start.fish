function ssh_agent_start --description "Start the ssh-agent if it has not been started yet"
  if ssh_agent_is_running
    return 1
  end
  if test -z "$SSH_ENV"
    set -xg SSH_ENV "$HOME/.ssh/environment"
  end
  ssh-agent -c | head -n -1 > $SSH_ENV
  chmod 600 $SSH_ENV
  source $SSH_ENV > /dev/null
  true
end

