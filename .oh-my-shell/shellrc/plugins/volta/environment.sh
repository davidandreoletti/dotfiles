if command_exists volta; then
    # Install the volta shim in ~/profile scripts: https://docs.volta.sh/reference/setup
    # - define VOLTA_HOME
    # - add $VOLTA_HOME/bin to PATH
    volta setup --quiet
fi
