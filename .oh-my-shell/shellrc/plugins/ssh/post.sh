# src: https://unix.stackexchange.com/a/217223/45954
# src: https://unix.stackexchange.com/a/90869/45954

# Add "AddKeysToAgent yes" to hosts (stored in your ~/.ssh/config) whose keys should be kept by the ssh-agent, when first unlocked
# Don't use: ssh-add -l > /dev/null || ssh-add

# Load a single ssh-agent instance across all terminal sessions
# src: https://stackoverflow.com/a/32592488/219728
USER_SSH_AGENT_ENV="$HOME/.ssh/.ssh_agent_env"
agentPid=$(pgrep -u "$USER" "ssh-agent")
if [[ "$agentPid" == "" ]]; then
    # No ssh-agent running, start it
    eval $(ssh-agent) > /dev/null
    # Remove eventual previous ssh-agent environment configuration
    rm -f "$USER_SSH_AGENT_ENV" 2> /dev/null
    touch "$USER_SSH_AGENT_ENV" 2> /dev/null
    # Add new ssh-agent environment configuration
    echo 'export SSH_AUTH_SOCK'=$SSH_AUTH_SOCK >> "$USER_SSH_AGENT_ENV"
    echo 'export SSH_AGENT_PID'=$SSH_AGENT_PID >> "$USER_SSH_AGENT_ENV"
else
    [[ -f "$USER_SSH_AGENT_ENV" ]] && source "$USER_SSH_AGENT_ENV"
fi

