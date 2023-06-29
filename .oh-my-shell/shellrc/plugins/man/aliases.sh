# Use tldr when CLI_APP_NAME is documented. Otherwise, fallback to standard man
# Usage: man CLI_APP_NAME
alias man='f_man_prefer_tldr_when_available '

# Always use default man page for CLI_APP_NAME 
# Usage: oman CLI_APP_NAME
alias oman='command man '
