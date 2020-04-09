function _timeNow() {
  #startTime=$(command date "+%s000")
  startTime=$(command date "+%s%3N")
  startTime="${startTime//[!0-9]/}"
  echo "$startTime"
}

function _timeInterval() {
    local startTime=$1
    local endTime=$2
    local runtime=$(echo "$endTime - $startTime" | bc)
    echo "$runtime"
}

function _reportIfSlowerThan() {
    local id=$1
    local measured=$2
    local max=${3:-200} # in milliseconds

    # Report scripts loading slower
    if [[ $measured -gt $max ]];
    then
        #echo "$startTime > $endTime"
        echo "$measured ms -> $id"
    fi 
}


# Execute commands in listed files, in the current environment
# Usage: dot "file1.sh" "file2.sh"
function dot() {
  for f in "$@"
  do
      #echo source $(basename $f)
      . $f
  done
}

# Execute commands in listed files, in the current environment, for files that exist
# Usage: dot_if_exists "file1.sh" "file2.sh"
function dot_if_exists() {
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
function dot_first_if_exists() {
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

function if_dir_exists() {
    [ -d $1 ] && [ -r $1 ]
    return
}

function shell_session_step_file () {
    local stepName="${1:-"none"}"
    local filePath="/tmp/${USER}_${SHELL_SESSION_ID}_$stepName"
    echo "$filePath"
}

# Usage: dot_delayed_plugins_step_if_exists STEP NAME
function dot_delayed_plugins_step_if_exists() {
    local stepName="${1:-"none"}"

    local startTime=$(_timeNow)

    local stepFile=$(shell_session_step_file "$stepName")
    dot_if_exists "$stepFile"
    rm -f "$stepFile"

    local endTime=$(_timeNow)
    local runtime=$(_timeInterval $startTime $endTime)
    #_reportIfSlowerThan "delayed_plugin: $stepName" $runtime 100
}

# Usage: dot_plugin_if_exists PLUGIN_NAME
function dot_plugin_if_exists() {
    local pluginName="${1:-"none"}"

    local startTime=$(_timeNow)

    export SHELLRC_CURRENT_PLUGIN_DIR="${SHELLRC_PLUGINS_DIR}/${pluginName}"
    if_dir_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/bin" && path_prepend "${SHELLRC_CURRENT_PLUGIN_DIR}/bin"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/environment.sh"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/functions.sh"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/aliases.sh"

    local stepCompletionFile=$(shell_session_step_file "completions")
    echo "dot_if_exists ${SHELLRC_CURRENT_PLUGIN_DIR}/completions.sh" >> "$stepCompletionFile"

    local stepPostFile=$(shell_session_step_file "post")
    echo "dot_if_exists ${SHELLRC_CURRENT_PLUGIN_DIR}/post.sh" >> "$stepPostFile"
    unset SHELLRC_CURRENT_PLUGIN_DIR 

    local endTime=$(_timeNow)
    local runtime=$(_timeInterval $startTime $endTime)
    #_reportIfSlowerThan "plugin: $pluginName" $runtime 90
}

# Usage: dot_current_shell_plugin_if_exists PLUGIN_NAME
dot_current_shell_plugin_if_exists() {
    local pluginName="${1:-"none"}"
    export SHELLRC_CURRENT_PLUGIN_DIR="${SHELLRC_CURRENT_SHELL_DIR}/${pluginName}"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/default.sh"
    unset SHELLRC_CURRENT_PLUGIN_DIR 
}

