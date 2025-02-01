# Look into this https://github.com/junegunn/fzf/wiki/examples#git

# Perform "git pull" on all local reposities ending with '.git' _directly_ under the specificed path
# usage: f_git_pullUpdatesForAllRepositoriesAtPath "/PATH/TO/DIR/"
function f_git_pullUpdatesForAllRepositoriesAtPath() {
    # src: https://stackoverflow.com/q/3497123/219728
    local dirPath="$1"
    find $dirPath -type d -name '*.git' -maxdepth 1 -mindepth 1 | xargs -n1 -I % bash -x -c 'cd %; cd $(git rev-parse --show-toplevel) && git pull'
}

# Set file's user execubable bit and save change in git
function f_git_setUserExecutableBit() {
    local file="$1"

    chmod u+x "$file"
    git update-index --verbose --chmod=+x "$file"
}

# Reset commit author for child commits starting (inclusive) at the given commit
function f_git_resetAuthor() {
    local commitHash="$1"

    # src: https://stackoverflow.com/a/1320317/219728
    git rebase --root -r "$commitHash" \
        --exec 'git commit --amend --no-edit --reset-author'
}
