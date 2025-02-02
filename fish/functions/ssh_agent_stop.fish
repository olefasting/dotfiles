function ssh_agent_stop --description "Stop the ssh-agent if it is running"
  if not ssh_agent_is_running
    return 1
  end
  command ssh-agent -k
end
