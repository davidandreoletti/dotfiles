#!/usr/bin/env bash
#src: https://raw.githubusercontent.com/denisidoro/dotfiles/0e7324f801ebb209650e1bae6f0bf30d9a5c7a37/scripts/self/lint
set -euo pipefail

##? Lint own files
##?
##? Usage:
##?    lint [options]
##?
##? Options:
##?    --no-bash          Skip bash lints

f_all_dotfiles_files() {
    local dir="$1"
    test -d "$dir/.oh-my-shell" && find "$dir/.oh-my-shell" -iname "*.sh" -type f
    test -d "$dir/.bin" && find "$dir/.bin" -executable -type f
    test -d "$dir/.self" && find "$dir/.self" -iname "*.sh" -type f
    test -d "$dir/" && find "$dir/" -maxdepth 1 -iname "*.sh" -type f
    test -d "$dir/" && find "$dir/" -maxdepth 1 -iname "*.zsh" -type f
    test -d "$dir/" && find "$dir/" -maxdepth 1 -iname "*.bash" -type f
}

f_dedupe() {
    sort -u
}

f_filter() {
    grep -v '.py\|beautify\|docopts\|node_modules\|modules\|clojure/compile\|info/bar\|vscode\|hushlogin\|DS_S\|bin/dot|themes/core.zsh'
}

f_all_dotfiles_files_to_format() {
    local dir="$1"

    f_all_dotfiles_files "$dir" \
        | f_dedupe \
        | f_filter \
        | sed "s|${dir}|.|g"
}

PARRALLEL=$(nproc)
for dir in "$DOTFILES_HOME_LOCAL" "$DOTFILES_PRIVATE_HOME_LOCAL"; do
    pushd "$dir" >/dev/null
    echo "=> $dir"
    #echo "- files"
    #f_all_dotfiles_files_to_format "$dir"
    echo "- formatting"
    # Format scripts
    f_all_dotfiles_files_to_format "$dir" \
        | f_dedupe \
        | xargs -I% -n1 -P${PARRALLEL} $DOTFILES_HOME_LOCAL/.self/format.sh write "%"

    echo "- fixing"
    # Fix posix scripts only
    f_all_dotfiles_files_to_format "$dir" \
        | f_dedupe \
        | grep "\.sh$" \
        | xargs -I% -n1 -P${PARRALLEL} $DOTFILES_HOME_LOCAL/.self/shellcheck.sh fix "$dir" "%"

    echo "- manual fixes required"
    # Print unfixable posix scripts only
    f_all_dotfiles_files_to_format "$dir" \
        | f_dedupe \
        | grep "\.sh$" \
        | xargs -I% -n1 -P${PARRALLEL} $DOTFILES_HOME_LOCAL/.self/shellcheck.sh unfixable "$dir" "%"

    echo "- done"

    # Test posix scripts only
    #f_all_dotfiles_files_to_format "$dir" \
    #    | f_dedupe \
    #    | grep "\.sh$" \
    #    | xargs -I% -n1 -P${PARRALLEL} $DOTFILES_HOME_LOCAL/.self/shellcheck.sh fix "%"
    popd >/dev/null
done
