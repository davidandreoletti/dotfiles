# Load Bash/ZSH completion + path
if command -v gcloud >/dev/null 2>&1; then
    shellNameLowercase=$(basename $SHELL | tr '[:upper:]' '[:lower:]')

    # Completion file: '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
    completionFile="$(homebrew_cask_package_path_prefix google-cloud-sdk)/latest/google-cloud-sdk/completion.$shellNameLowercase.inc"
    # Path file: '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
    pathFile="$(homebrew_cask_package_path_prefix google-cloud-sdk)/latest/google-cloud-sdk/path.$shellNameLowercase.inc"
    
    . "$completionFile"
    . "$pathFile"
fi

