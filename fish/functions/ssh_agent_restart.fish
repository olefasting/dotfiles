function ssh_agent_restart --description "Restart the ssh-agent if it is running or start it if not"
  if ssh_agent_is_running
    ssh_agent_stop
  end
  ssh_agent_start
end
