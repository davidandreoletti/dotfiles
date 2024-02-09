# On linux, define XDG_ env vars since XDG_ are optional env variables as per the spec
# On macOS, XDG_ env vars defined via launchd
if is_linux; then
    export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
    export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
    export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
    export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
elif is_macos; then
    PLUGIN_LAUNCHD_POST_PLIST="org.__USER__.xdg.environment.plist"
    PLUGIN_LAUNCHD_POST_WAIT_DURATION="1"
    . $SHELLRC_PLUGINS_DIR/launchd/post.sh
    unset -v "PLUGIN_LAUNCHD_POST_PLIST"
    unset -v "PLUGIN_LAUNCHD_POST_WAIT_DURATION"
fi

# Create missing XDG folders
if is_macos; then
    # Keep synced with .config/launch/org.__USER__.environment.plist's XDG_xxxx var
    for xdg in "XDG_CONFIG_HOME" "XDG_CACHE_HOME" "XDG_DATA_HOME" "XDG_STATE_HOME"; do
        xdg_path="$(eval "echo \"\$$xdg\"")"

        if test -z "$xdg_path";
        then
            echo "$xdg is not defined. Forgot to load ~/Library/LaunchAgents/org.$USER.xdg.environment.plist ?"
            echo "Existing in 15s. Press Ctrl-C to cancel"
            sleep 15 && exit 1
        else
            # Create path when missing
            test -d "$xdg_path" || mkdir -p -m 0750 "$xdg_path"
        fi
    done
fi

# Define user local shell completion
if is_zsh; then
    export ZSH_COMPLETION_USER_DIR="$XDG_DATA_HOME/zsh-completion.d"
    export SHELLRC_COMPLETION_USER_DIR="$ZSH_COMPLETION_USER_DIR"
elif is_bash; then
    export BASH_COMPLETION_USER_DIR="$XDG_DATA_HOME/bash-completion.d"
    export SHELLRC_COMPLETION_USER_DIR="$BASH_COMPLETION_USER_DIR"
fi

! test -d "$SHELLRC_COMPLETION_USER_DIR" && mkdir -p "$SHELLRC_COMPLETION_USER_DIR"
