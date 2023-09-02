# Init conda:
# - init code completion, etc
if [[ "$OS_NAME" == "macosx" ]];
then
    [ -d "$HOME/.conda" ] || ( conda init --quiet $SHELL_NAME )
else
    # Linux does not seem to need it per shell instance
    # However sudo conda init --quiet ran during bootstrap_apps.sh
    :
fi

