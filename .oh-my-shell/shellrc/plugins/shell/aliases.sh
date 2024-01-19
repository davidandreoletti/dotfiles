# Reload current shell's profile
# Usage: shell_reload_profile
alias shell_reload_profile="source $SHELL_ROOT_PROFILE || echo \"No shell profile found at $SHELL_ROOT_PROFILE\""

# Clear shell + tmux's screen
alias shell_clear_all="clear; tmux clear-history;"

# Print shell variables
alias shell_print_variables='(set -o posix; set)'
