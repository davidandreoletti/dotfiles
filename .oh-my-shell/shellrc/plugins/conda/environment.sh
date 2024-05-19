# Init conda:
# - init code completion, etc
if is_macos; then
    [ -d "$HOME/.conda" ] || (conda init --quiet $SHELL_NAME)
elif is_fedora; then
    # condabin contains only the conda binary
    path_prepend "/opt/conda/condabin/"
    [ -d "$HOME/.conda" ] || (conda init --quiet $SHELL_NAME)
else
    # Linux does not seem to need it per shell instance
    # However sudo conda init --quiet ran during bootstrap_apps.sh
    :
fi
