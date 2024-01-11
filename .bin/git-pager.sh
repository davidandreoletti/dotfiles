# Set pager to display raw control characters

pagerType=${1:-"simple"}
shift

case "$pagerType" in
    "simple")
        less -r
        ;;
    "diff")
        # FIXME: Use HOMEBREW_PACKAGES_xxxx_DIR variable set in .oh-my-shell/functions.sh
        GIT_DIFF_HIGHLIGHT="$(brew --prefix git)/share/git-core/contrib/diff-highlight/diff-highlight"
        if [ -r "$GIT_DIFF_HIGHLIGHT" ] 
        then
            $GIT_DIFF_HIGHLIGHT | less
        else
            less -r
        fi
        ;;
    "delta")
        # FIXME: Use HOMEBREW_PACKAGES_xxxx_DIR variable set in .oh-my-shell/functions.sh
        GIT_DELTA="$(brew --prefix git-delta)/bin/delta"
        if [ -r "$GIT_DELTA" ]
        then
            $GIT_DELTA "$@" | less
        else
            less -r
        fi
        ;;
    *)
        less -r
        ;;
esac
