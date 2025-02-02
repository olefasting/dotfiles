function ssh_agent_is_running --description "Check if ssh agent is running"
   if begin; test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"; end
      source $SSH_ENV > /dev/null
   end
   if test -z "$SSH_AGENT_PID"
      return 1
   end
   ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep -q ssh-agent | pgrep ssh-agent > /dev/null
   return $status
end
