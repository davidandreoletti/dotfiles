# FIXME: This does not work well with multiple 'usage:' tags
function f_alias_search() {
    alias | \
        cut -d'=' -f1 | \
        fzf --cycle --no-multi \
            --preview-window up \
            --preview "grep -B 10 '{}' ~/.oh-my-shell/shellrc/plugins/*/aliases.sh | ggrep  -Pzo '(?<=sh-\n)(.|\n)*(?={})' | grep -v ':alias ' "
}
