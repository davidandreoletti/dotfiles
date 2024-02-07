# Load Bash/ZSH completion + path
if command_exists 'gcloud'; then
    # Path file: '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
    pathFile="$(homebrew_cask_package_path_prefix google-cloud-sdk)/latest/google-cloud-sdk/path.${SHELL_NAME}.inc"
    dot_if_exists "$pathFile"
fi
