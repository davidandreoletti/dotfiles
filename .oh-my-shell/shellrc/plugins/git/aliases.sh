# Usage: Perform "git pull" on all local reposities ending with '.git' _directly_ under the specificed path
# usage: gitPullUpdatesForAllGitRepositoriesAtPath "/PATH/TO/DIR/"
alias gitPullUpdatesForAllGitRepositoriesAtPath='f_git_pullUpdatesForAllRepositoriesAtPath '

# (As of v0.20.x) Lazygit does not read config file from ~/.config/lazygit on macOS
# src: https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#user-config
alias lazygit="XDG_CONFIG_HOME=$HOME/.config lazygit"

# Display git TUI
# Usage: tgit
alias tgit=lazygit
