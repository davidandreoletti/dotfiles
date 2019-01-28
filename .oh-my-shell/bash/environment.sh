# Load bash completions
# Note: List all completions routine with "complete -p"
[[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
[[ -r "$(brew --prefix fzf)/shell/completion.bash" ]] && . "$(brew --prefix fzf)/shell/completion.bash"

