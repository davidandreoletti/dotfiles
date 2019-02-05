# Set pager to display raw control characters

pagerType=${1:-"simple"}

case "$pagerType" in
    "simple")
        less -r
        ;;
    "diff")
        # FIXME: Use HOMEBREW_PACKAGES_xxxx_DIR variable set in .oh-my-shell/functions.sh
        # FIXME: Will break on debian based OSes
        GIT_DIFF_HIGHLIGHT="$(brew --prefix git)/share/git-core/contrib/diff-highlight/diff-highlight"
        if [ -r "$GIT_DIFF_HIGHLIGHT" ] 
        then
            $GIT_DIFF_HIGHLIGHT | less
        else
            less -r
        fi
        ;;
    *)
        less -r
        ;;
esac
