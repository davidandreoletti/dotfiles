ask_user_password() {
    message_info_show "Enter $(whoami)'s password (required):"
    read -s p
    echo "$p" | sudo -S echo ""
}
