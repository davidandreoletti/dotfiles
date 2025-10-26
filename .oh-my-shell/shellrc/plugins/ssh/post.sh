# src: https://unix.stackexchange.com/a/217223/45954
# src: https://unix.stackexchange.com/a/90869/45954

# Overview:
# 0. ssh client configured to store keys into a ssh-agent
#    Add "AddKeysToAgent yes" to hosts (stored in your ~/.ssh/config) whose keys should be kept by the ssh-agent, when first unlocked
#    Don't use this in scripts as it would load all keys: ssh-add -l > /dev/null || ssh-add
# 1. ssh client needs a ssh private key
# 2. ssh client store ssh private key into ssh-agent
#    - this script helps store the private key into an ssh-agent you configured

# Create ssh-agent setup script
SSH_AGENT_SETUP_SCRIPT="/tmp/$USER.ssh_agent_setup.sh"

cat <<EOF >$SSH_AGENT_SETUP_SCRIPT
    #Debug script
    #set -x
    #exec >> /tmp/\$USER.\$PID.ssh.agent.setup.log
    #exec 2>&1

    USER_SSH_AGENT_ENV="\$1"
    USER_SSH_AGENT_ENV_NAME="\$(basename \$1)"

    mkdir -p "\$(dirname \$USER_SSH_AGENT_ENV)"

    # Try to load current ssh-agent
    if test -f \$USER_SSH_AGENT_ENV; then
        source \$USER_SSH_AGENT_ENV
    else
        SSH_AGENT_PID='missing'
    fi

    # Find ssh-agent process
    agentPids="\$(pgrep -u $USER 'ssh-agent')"
    if echo "\$agentPids" | grep -q "\$SSH_AGENT_PID"; then
        # Configured agent is also a running agent
        exit 0
    fi

    # Configured agent is gone. Recreating a new agent"
    # Start new ssh-agent
    # SSH_USE_STRONG_RNG might block on computer lacking enough entropy
    # (such as device without a hardware random generator)
    export SSH_USE_STRONG_RNG=1

    if test "\$USER_SSH_AGENT_ENV_NAME" = "default"; then
        eval \$(ssh-agent -t 3600) >/dev/null
    else
        eval \$(ssh-agent) >/dev/null
    fi

    # Remove eventual previous ssh-agent environment configuration
    command rm -f "\$USER_SSH_AGENT_ENV" 2>/dev/null
    touch "\$USER_SSH_AGENT_ENV" 2>/dev/null

    # Add new ssh-agent environment configuration
    echo 'export SSH_AUTH_SOCK'=\$SSH_AUTH_SOCK >>"\$USER_SSH_AGENT_ENV"
    echo 'export SSH_AGENT_PID'=\$SSH_AGENT_PID >>"\$USER_SSH_AGENT_ENV"

    # Link ssh-agent socket to normalized paths
    socket_link="\$HOME/.ssh/agent/env/\$USER_SSH_AGENT_ENV_NAME.socket"
    ln -s -f "\$SSH_AUTH_SOCK" "\$socket_link"
    chmod 600 "$socket_link"
EOF

# Create a single ssh-agent instance across all terminal sessions, for each predefined agent
# src: https://stackoverflow.com/a/32592488/219728

USER_SSH_AGENT_DIR="$HOME/.ssh/agent"
USER_SSH_AGENT_ENV_0="$USER_SSH_AGENT_DIR/env/default"
USER_SSH_AGENT_ENV_1="$USER_SSH_AGENT_DIR/env/unsecure"

for f in "$USER_SSH_AGENT_ENV_0" "$USER_SSH_AGENT_ENV_1"; do
    # Create missing folders
    mkdir -p "$(dirname $f)"

    # Run ssh agent setup script
    flock --exclusive --unlock \
        "${f}.lock" \
        -c "bash $SSH_AGENT_SETUP_SCRIPT $f"

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

command rm -f "$SSH_AGENT_SETUP_SCRIPT"
