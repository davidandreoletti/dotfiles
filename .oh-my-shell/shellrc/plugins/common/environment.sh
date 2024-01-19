# Homebrew
# Note: Use homebrew in priority (outside the homebrew plugin because some plugins called before homebrew plugin is called need 'brew' to be in the PATH)
# case: macos
[ -d "/usr/local/bin" ] && export PATH=/usr/local/bin:$PATH
# case: linux
[ -d "/home/linuxbrew/.linuxbrew/bin" ] && export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

export PATH

# Check XDG directories exist
if is_macos; then
    # Keep synced with .config/launch/org.david.environment.plist's XDG_xxxx var
    for xdg in XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME; do
        [ -z "$xdg" ] && echo "$xdg is not defined"
        [ ! -z "$xdg" ] && ([ -d "$xdg" ] || mkdir -m 0750 "$xdg")
    done
fi
