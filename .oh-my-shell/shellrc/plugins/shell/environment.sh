SHELL_NAME=$(get_shell_type)

if [ "$SHELL_NAME" = "bash" ];
then
    SHELL_ROOT_PROFILE="$HOME/.bash_profile"
elif [ "$SHELL_NAME" = "zsh" ];
then
    SHELL_ROOT_PROFILE="$HOME/.zshrc"
fi

