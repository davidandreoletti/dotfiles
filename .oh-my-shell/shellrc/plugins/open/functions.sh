# Open file
# src: https://github.com/junegunn/fzf/wiki/examples#opening-files
#fe() {
f_open_files_in_editor() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fe's Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
# src: https://github.com/junegunn/fzf/wiki/examples#opening-files
#fo() {
f_open_files_in_editor_or_open() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

# fuzzy grep open via ag
# src: https://github.com/junegunn/fzf/wiki/examples#opening-files
# vg() {
#   local file
# 
#   file="$(ag --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1}')"
# 
#   if [[ -n $file ]]
#   then
#      vim $file
#   fi
# }

# fda - cd to selected directory, including hidden directories
# https://github.com/junegunn/fzf/wiki/examples#opening-files
#fda() {
f_open_selected_directory () {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# fdr - cd to selected parent directory
# https://github.com/junegunn/fzf/wiki/examples#opening-files
#fdr() {
f_open_selected_parent_directory () {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
  cd "$DIR"
}
