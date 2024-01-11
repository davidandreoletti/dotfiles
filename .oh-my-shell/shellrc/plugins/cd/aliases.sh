# Move current directory path X folder up
# Usage: up 3
#        -> will move from /path/1/2/3 to /path
alias up='f_cd_up_to_nth_dir'

# Use cd with pushd
# usage: cd somewhore
alias cd='f_cd_pushd'

# Move back to previous working directory path
# usage: cd somewhore
alias cd-='f_cd_pushd -'

# Move to fuzzy
# usage: cdi
alias cdi='f_cd_zoxide'

# Show current directory stack
# usage: cd_stack
alias cd_stack='dirs -v'

# Clear directory stack
# usage: cd_stack_clear
alias cd_stack_clear='dirs -c'

