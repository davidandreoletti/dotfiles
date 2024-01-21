# Homebrew
# Note: Use homebrew in priority (outside the homebrew plugin because some plugins called before homebrew plugin is called need 'brew' to be in the PATH)
is_macos && [ -d "/usr/local/bin" ] && path_prepend "/usr/local/bin"
is_linux && [ -d "/home/linuxbrew/.linuxbrew/bin" ] && path_prepend "/home/linuxbrew/.linuxbrew/bin"

# Check XDG directories exist
if is_macos; then
    # Keep synced with .config/launch/org.david.environment.plist's XDG_xxxx var
    for xdg in "XDG_CONFIG_HOME" "XDG_CACHE_HOME" "XDG_DATA_HOME" "XDG_STATE_HOME"; do
        xdg_path="$(eval "echo \"\$$xdg\"")"

        if test -z "$xdg_path";
        then
            echo "$xdg is not defined."
            is_kitty_terminal_app && echo "Do not use this terminal as daily driver"
            echo "Existing in 15s. Press Ctrl-C to cancel"
            sleep 15 && exit 1
        else
            # Create path when missing
            test -d "$xdg_path" || mkdir -p -m 0750 "$xdg_path"
        fi
    done
fi
