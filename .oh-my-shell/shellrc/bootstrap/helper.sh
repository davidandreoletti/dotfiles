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

if_dir_exists() {
    [ -d $1 ] && [ -r $1 ]
    return
}

# Usage: dot_plugin_if_exists PLUGIN_NAME
dot_plugin_if_exists() {
    local pluginName="${1:-"none"}"

    #set -x
    #startTime=$(command date "+%s%3N")
    #startTime="${startTime//[!0-9]/}"
    #set +x

    export SHELLRC_CURRENT_PLUGIN_DIR="${SHELLRC_PLUGINS_DIR}/${pluginName}"
    if_dir_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/bin" && path_prepend "${SHELLRC_CURRENT_PLUGIN_DIR}/bin"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/environment.sh"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/functions.sh"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/aliases.sh"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/completions.sh"
    # FIXME: post.sh must be executed when all plugins have been initialized
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/post.sh"
    unset SHELLRC_CURRENT_PLUGIN_DIR 

    #set -x
    #endTime=$(command date "+%s%3N")
    #endTime="${endTime//[!0-9]/}"
    #runtime=$(echo "$endTime - $startTime" | bc)
    #set +x
    # Report plugins loading slower than 200 milliseconds
    #if [[ $runtime -gt 200 ]];
    #then
    #    #echo "$startTime > $endTime"
    #    echo "$runtime ms -> $pluginName"
    #fi
}

# Usage: dot_current_shell_plugin_if_exists PLUGIN_NAME
dot_current_shell_plugin_if_exists() {
    local pluginName="${1:-"none"}"
    export SHELLRC_CURRENT_PLUGIN_DIR="${SHELLRC_CURRENT_SHELL_DIR}/${pluginName}"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/default.sh"
    unset SHELLRC_CURRENT_PLUGIN_DIR 
}


