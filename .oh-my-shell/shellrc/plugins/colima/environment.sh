if is_macos; then
    # Workaround for https://github.com/abiosoft/colima/issues/1036
    export LIMA_HOME="$HOME/.colima_lima"
    mkdir -p "$LIMA_HOME"
fi
