# Execute commands in listed files, in the current environment
# Usage: dot "file1.sh" "file2.sh"
dot() {
  for f in $*
  do
      #echo source $(basename $f)
      . $f
  done
}

# Execute commands in listed files, in the current environment, for files that exist
# Usage: dot_if_exists "file1.sh" "file2.sh"
dot_if_exists() {
    for f in $*
    do
        if [ -f $f ] && [ -r $f ]
        then
            #echo source $f
            . $f
        else
            #echo No source $f
            :
        fi
    done
}

# Execute commands in listed files, in the current environment, for the very first file that exist
# Usage: dot_if_exists "file1.sh" "file2.sh"
dot_first_if_exists() {
    for f in $*
    do
        if [ -f $f ] && [ -r $f ]
        then
            #echo source $f
            . $f
            return
        fi
    done
}

# Usage: dot_plugin_if_exists PLUGIN_NAME
dot_plugin_if_exists() {
    local pluginName="${1:-"none"}"
    export SHELLRC_CURRENT_PLUGIN_DIR="${SHELLRC_PLUGINS_DIR}/${pluginName}"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/environment.sh"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/functions.sh"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/aliases.sh"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/completions.sh"
    # FIXME: post.sh must be executed when all plugins have been initialized
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/post.sh"
    unset SHELLRC_CURRENT_PLUGIN_DIR 
}

# Usage: dot_current_shell_plugin_if_exists PLUGIN_NAME
dot_current_shell_plugin_if_exists() {
    local pluginName="${1:-"none"}"
    export SHELLRC_CURRENT_PLUGIN_DIR="${SHELLRC_CURRENT_SHELL_DIR}/${pluginName}"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/default.sh"
    unset SHELLRC_CURRENT_PLUGIN_DIR 
}


