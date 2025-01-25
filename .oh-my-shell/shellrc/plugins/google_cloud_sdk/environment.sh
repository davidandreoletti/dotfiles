# Load Bash/ZSH completion + path
if command_exists 'gcloud'; then
    # Path file: '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
    pathFile="$(homebrew_cask_package_path_prefix google-cloud-sdk)/latest/google-cloud-sdk/path.${SHELL_NAME}.inc"
    dot_if_exists "$pathFile"

    # Completion file: '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
    completionFile0="$(homebrew_cask_package_path_prefix google-cloud-sdk)/latest/google-cloud-sdk/completion.${SHELL_NAME}.inc"
    completionFile1="/usr/lib64/google-cloud-sdk/completion.${SHELL_NAME}.inc"

    for f in $completionFile0 $completionFile1; do
        test -f "$f" && ln -sf "$f" "${SHELLRC_COMPLETION_USER_DIR}/_gcloud" && break
    done
fi
