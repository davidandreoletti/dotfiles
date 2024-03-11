ask_user_password() {
    message_info_show "Enter password for $(whoami) (required):"
    read -s p
    echo "$p" | sudo -S echo ""
}
