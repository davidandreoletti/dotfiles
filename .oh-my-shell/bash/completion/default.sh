# Load bash completions
# Note: List all completions routine with "complete -p"

# Completion for installed homebrew packages, with completion profile.d support  
HOMEBREW_PROFILED_COMPLETION_DIR=$(homebrew_package_path_prefix "/etc/profile.d/bash_completion.sh")
dot_if_exists "$HOMEBREW_PROFILED_COMPLETION_DIR"

# Completion for installed homebrew packages, without completion profile.d support  
HOMEBREW_FZF_COMPLETION_DIR=$(homebrew_package_path_prefix "/fzf/shell/completion.bash")
dot_if_exists "$HOMEBREW_FZF_COMPLETION_DIR"
