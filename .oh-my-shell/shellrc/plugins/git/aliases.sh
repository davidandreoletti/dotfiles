# Usage: Perform "git pull" on all local reposities ending with '.git' _directly_ under the specificed path
# usage: git_pull_updates_for_all_git_repositories_at_path "/PATH/TO/DIR/"
alias git_pull_updates_for_all_git_repositories_at_path='f_git_pullUpdatesForAllRepositoriesAtPath '

# (As of v0.20.x) Lazygit does not read config file from ~/.config/lazygit on macOS
# src: https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#user-config
alias lazygit="XDG_CONFIG_HOME=$HOME/.config lazygit"

# Display git TUI
# Usage: tgit
alias tgit=lazygit
