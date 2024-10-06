if command_exists "nnn"; then
    # Install nnn's plugins, overwriting them when needed
    yes 'm' | sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"
fi
