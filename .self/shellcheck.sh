#!/usr/bin/env bash
# src: https://github.com/denisidoro/dotfiles/blob/0e7324f801ebb209650e1bae6f0bf30d9a5c7a37/scripts/self/shellcheck#L6

set -euo pipefail

mode="${1:-ls}"

# Shellcheck
#
# usage: shellcheck fix <dotfile local dir> <shell script>
# usage: shellcheck unfixable <dotfile local dir> <shell script>

f_fix() {
   local dir="$2"
   local file="$3" 

   shellcheck -x -f diff "$(realpath "$file")" \
      | sed "s|${dir}|.|g" \
      | sed 's|././tests|./tests|g' \
      | git apply
}

f_unfixable() {
   local dir="$2"
   local file="$3" 

   shellcheck -x -f tty "$(realpath "$file")"
}
