DOCKER_CLI_PLUGIN_DIR="$HOME/docker/cli-plugins"

if ! test -d "$DOCKER_CLI_PLUGIN_DIR"; then
    # (a) docker-buildx recommends to:
    #  - add "$HOMEBREW_PREFIX/lib/docker/cli-plugins" to ~/.docker/config.json's cliPluginsExtraDirs
    # (b) colima recommends to:
    #  - create "ln -sfn $(which docker-buildx) ~/.docker/cli-plugins/docker-buildx" but I prefer pre-configured files
    #
    #  Solution: Prefer (a)
    mkdir -p "$DOCKER_CLI_PLUGIN_DIR"
fi
