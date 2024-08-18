# src: https://unix.stackexchange.com/a/217223/45954
# src: https://unix.stackexchange.com/a/90869/45954

# Add "AddKeysToAgent yes" to hosts (stored in your ~/.ssh/config) whose keys should be kept by the ssh-agent, when first unlocked
# Don't use: ssh-add -l > /dev/null || ssh-add

# Create ssh-agent setup script
SSH_AGENT_SETUP_SCRIPT="/tmp/$USER.ssh_agent_setup.sh"

cat <<EOF >$SSH_AGENT_SETUP_SCRIPT
    USER_SSH_AGENT_ENV="\$1"

    mkdir -p "\$(dirname \$USER_SSH_AGENT_ENV)"

    # Try to load current ssh-agent
    if test -f \$USER_SSH_AGENT_ENV; then
	source \$USER_SSH_AGENT_ENV
    else
	SSH_AGENT_PID='missing'    
    fi

    agentPids="\$(pgrep -u $USER 'ssh-agent')"
    if echo "\$agentPids" | grep -q "\$SSH_AGENT_PID"; then
        # Configured agent is also a running agent
        exit 0
    fi

    # Configured agent is gone. Recreating a new agent"
    # Start new ssh-agent
    eval \$(ssh-agent) >/dev/null

    # Remove eventual previous ssh-agent environment configuration
    command rm -f "\$USER_SSH_AGENT_ENV" 2>/dev/null
    touch "\$USER_SSH_AGENT_ENV" 2>/dev/null

    # Add new ssh-agent environment configuration
    echo 'export SSH_AUTH_SOCK'=\$SSH_AUTH_SOCK >>"\$USER_SSH_AGENT_ENV"
    echo 'export SSH_AGENT_PID'=\$SSH_AGENT_PID >>"\$USER_SSH_AGENT_ENV"
EOF

# Create a single ssh-agent instance across all terminal sessions, for each predefined agent
# src: https://stackoverflow.com/a/32592488/219728

USER_SSH_AGENT_DIR="$HOME/.ssh/.agent"
USER_SSH_AGENT_ENV_0="$USER_SSH_AGENT_DIR/env_default"
USER_SSH_AGENT_ENV_1="$USER_SSH_AGENT_DIR/env_unsecure"

for f in "$USER_SSH_AGENT_ENV_0" "$USER_SSH_AGENT_ENV_1"; do
    flock --exclusive --unlock \
        "${f}.lock" \
        -c "bash -x $SSH_AGENT_SETUP_SCRIPT $f"

    if test "$f" != "$USER_SSH_AGENT_ENV_0"; then
        continue
    fi

    # Load pre-configured 'default' ssh-agent instance
    if ! test -f "$f"; then
        echo "WARNING: No SSH Agent instance were found"
    else
        . "$f"
    fi
done
