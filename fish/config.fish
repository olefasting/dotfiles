if status is-interactive
  ssh_agent_start
  starship init fish | source
end
