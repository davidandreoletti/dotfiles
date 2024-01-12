function _timeNow() {
  if [[ -z "$SHELLRC_PROFILE" ]]; 
  then
    echo "0"
   else
    # Get time with milliseconds precision
    startTime=${EPOCHREALTIME:0:14} # Requires bash 5.0 or zsh 5.x
    startTime=${startTime//.}
    
    # Note: DO NOT USE THESE - they have different behaviour on macOS's BSD date vs GNU date
    #startTime=$(command date "+%s000")
    #startTime=$(command date "+%s%3N")
    #startTime="${startTime//[!0-9]/}"
    echo "$startTime"
   fi 
}

function _timeInterval() {
  if [[ -z "$SHELLRC_PROFILE" ]]; 
  then
    echo "0"
  else
    local startTime=$1
    local endTime=$2
    local runtime=$(echo "$endTime - $startTime" | bc)
    echo "$runtime"
  fi
}

function _reportIfSlowerThan() {
  if [[ ! -z "$SHELLRC_PROFILE" ]]; 
  then
    local id=$1
    local measured=$2
    local max=${3:-200} # in milliseconds

    # Report scripts loading slower
    if [[ $measured -gt $max ]];
    then
        #echo "$startTime > $endTime"
        echo "profiling:speed:$id: $measured ms. Expected less than $max ms"
    fi 
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
    local reportSpeedOverDurationMs="${2:-100}"

    local stepFile=$(shell_session_step_file "$stepName")

    while IFS= read -r pluginName;
    do
        export SHELLRC_CURRENT_PLUGIN_DIR="${SHELLRC_PLUGINS_DIR}/${pluginName}"
        local startTime=$(_timeNow)

        dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/${stepName}.sh"

        local endTime=$(_timeNow)
        local runtime=$(_timeInterval $startTime $endTime)
        _reportIfSlowerThan "plugin: $pluginName: $stepName": $runtime $reportSpeedOverDurationMs
        unset SHELLRC_CURRENT_PLUGIN_DIR 
    done < "$stepFile"

    command rm -f "$stepFile"
}

# Usage: dot_plugin_if_exists PLUGIN_NAME
function dot_plugin_if_exists() {
    local pluginName="${1:-"none"}"
    local reportSpeedOverDurationMs="${2:-50}"

    local startTime=$(_timeNow)

    export SHELLRC_CURRENT_PLUGIN_DIR="${SHELLRC_PLUGINS_DIR}/${pluginName}"
    if_dir_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/bin" && path_prepend "${SHELLRC_CURRENT_PLUGIN_DIR}/bin"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/environment.sh"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/functions.sh"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/aliases.sh"

    local stepCompletionFile=$(shell_session_step_file "completions")
    echo "$pluginName" >> "$stepCompletionFile"

    local stepPostFile=$(shell_session_step_file "post")
    echo "$pluginName" >> "$stepPostFile"
    unset SHELLRC_CURRENT_PLUGIN_DIR 

    local endTime=$(_timeNow)
    local runtime=$(_timeInterval $startTime $endTime)
    _reportIfSlowerThan "plugin: $pluginName" $runtime $reportSpeedOverDurationMs
    unset SHELLRC_CURRENT_PLUGIN_DIR 
}

# Usage: dot_current_shell_plugin_if_exists PLUGIN_NAME
function dot_current_shell_plugin_if_exists() {
    local pluginName="${1:-"none"}"
    export SHELLRC_CURRENT_PLUGIN_DIR="${SHELLRC_CURRENT_SHELL_DIR}/${pluginName}"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/default.sh"
    unset SHELLRC_CURRENT_PLUGIN_DIR 
}

