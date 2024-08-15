function _timeNow() {
    if [[ -z "$SHELLRC_PROFILE_SPEED" ]]; then
        echo "0"
    else
        # Get time with milliseconds precision
        startTime=${EPOCHREALTIME:0:14} # Requires bash 5.0 or zsh 5.x
        startTime=${startTime//./}

        # Note: DO NOT USE THESE - they have different behaviour on macOS's BSD date vs GNU date
        #startTime=$(command date "+%s000")
        #startTime=$(command date "+%s%3N")
        #startTime="${startTime//[!0-9]/}"
        echo "$startTime"
    fi
}

function _timeInterval() {
    if [[ -z "$SHELLRC_PROFILE_SPEED" ]]; then
        echo "0"
    else
        local startTime=$1
        local endTime=$2
        echo $(($endTime - $startTime))
    fi
}

function _reportIfSlowerThan() {
    if [[ ! -z "$SHELLRC_PROFILE_SPEED" ]]; then
        local idType=$1
        local idName=$2
        local idName2=$3
        local measured=$4
        local max=${5:-200} # in milliseconds

        # Report scripts loading slower
        if [[ $measured -gt $max ]]; then
            #echo "$startTime > $endTime"
            printf "profiling:speed:%-8.8s:%-15.15s:%-20.20s:%-6.6s ms. Expected less than %s ms\n" $idType $idName $idName2 $measured $max
        fi
    fi
}

# Execute commands in listed files, in the current environment
# Usage: dot "file1.sh" "file2.sh"
function dot() {
    for f in "$@"; do
        #echo source $(basename $f)
        . $f
    done
}

# Execute commands in listed files, in the current environment, for files that exist
# Usage: dot_if_exists "file1.sh" "file2.sh"
function dot_if_exists() {
    for f in $*; do
        if [ -f $f ] && [ -r $f ]; then
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
    for f in $*; do
        if [ -f $f ] && [ -r $f ]; then
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

function shell_session_step_file() {
    local stepName="${1:-"none"}"
    local filePath="/tmp/${USER}_${SHELL_SESSION_ID}_$stepName"
    echo "$filePath"
}

# Usage: dot_delayed_plugins_step_if_exists STEP NAME
function dot_delayed_plugins_step_if_exists() {
    local stepName="${1:-"none"}"
    local background="${2:-1}"
    local reportSpeedOverDurationMs="${3:-100}"

    local stepFile=$(shell_session_step_file "$stepName")

    if test -f "$stepFile"; then
        (
            {
                local stepLockFile="/tmp/$USER.oh_my_shellrc.$stepName.lock"
                exec {lock_fd}>"$stepLockFile" || exit 1
                flock -n "$lock_fd" || {
                    echo "$stepName post.sh lock failed: $stepLockFile" >&2
                    exit 1
                }

                while IFS= read -r pluginName; do
                    export SHELLRC_CURRENT_PLUGIN_DIR="${SHELLRC_PLUGINS_DIR}/${pluginName}"
                    local startTime=$(_timeNow)

                    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/${stepName}.sh"

                    local endTime=$(_timeNow)
                    local runtime=$(_timeInterval $startTime $endTime)
                    _reportIfSlowerThan "plugin" "$pluginName" "$stepName" $runtime $reportSpeedOverDurationMs
                    unset SHELLRC_CURRENT_PLUGIN_DIR
                done <"$stepFile"
                command rm -f "$stepFile"

                flock -u "$lock_fd"
            } &

            pid=$!

            if test $background -eq 0; then
                :
            else
                wait $pid
            fi
        )
    fi
}

# Usage: dot_plugin_if_exists PLUGIN_NAME
function dot_plugin_if_exists() {
    local pluginName="${1:-"none"}"
    local reportSpeedOverDurationMs="${2:-50}"
    local reportStepSpeedOverDurationMs="${2:-5}"

    local startTime=$(_timeNow)

    # plugin's bin dir
    local binStepStartTime=$(_timeNow)
    export SHELLRC_CURRENT_PLUGIN_DIR="${SHELLRC_PLUGINS_DIR}/${pluginName}"
    if_dir_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/bin" && path_prepend "${SHELLRC_CURRENT_PLUGIN_DIR}/bin"
    local binStepEndTime=$(_timeNow)
    local binStepRuntime=$(_timeInterval $binStepStartTime $binStepEndTime)
    _reportIfSlowerThan "plugin" "$pluginName" "bin" $binStepRuntime $reportStepSpeedOverDurationMs

    # plugin's *.sh files
    for step in "environment.sh" "functions.sh" "aliases.sh" "private/environment.sh" "private/functions.sh" "private/aliases.sh"; do
        local fileStep="${SHELLRC_CURRENT_PLUGIN_DIR}/$step"
        if test -f "$fileStep"; then
            local stepStartTime=$(_timeNow)
            dot_if_exists "$fileStep"
            local stepEndTime=$(_timeNow)
            local stepRuntime=$(_timeInterval $stepStartTime $stepEndTime)
            _reportIfSlowerThan "plugin" "$pluginName" "$step" $stepRuntime $reportStepSpeedOverDurationMs
        fi
    done

    # plugin's completion.sh file
    if test -f "${SHELLRC_CURRENT_PLUGIN_DIR}/completions.sh"; then
        local completionStepStartTime=$(_timeNow)
        local stepCompletionFile=$(shell_session_step_file "completions")
        echo "$pluginName" >>"$stepCompletionFile"
        local completionStepEndTime=$(_timeNow)
        local completionStepRuntime=$(_timeInterval $completionStepStartTime $completionStepEndTime)
        _reportIfSlowerThan "plugin" "$pluginName" "completion" $completionStepRuntime $reportStepSpeedOverDurationMs
    fi

    # plugin's post.sh file
    if test -f "${SHELLRC_CURRENT_PLUGIN_DIR}/post.sh"; then
        local postStepStartTime=$(_timeNow)
        local stepPostFile=$(shell_session_step_file "post")
        echo "$pluginName" >>"$stepPostFile"
        local postStepEndTime=$(_timeNow)
        local postStepRuntime=$(_timeInterval $postStepStartTime $postStepEndTime)
        _reportIfSlowerThan "plugin" "$pluginName" "post" $postStepRuntime $reportStepSpeedOverDurationMs
    fi

    unset SHELLRC_CURRENT_PLUGIN_DIR

    local endTime=$(_timeNow)
    local runtime=$(_timeInterval $startTime $endTime)
    _reportIfSlowerThan "plugin" "$pluginName" "total" $runtime $reportSpeedOverDurationMs
    unset SHELLRC_CURRENT_PLUGIN_DIR
}

# Usage: dot_current_shell_plugin_if_exists PLUGIN_NAME
function dot_current_shell_plugin_if_exists() {
    local pluginName="${1:-"none"}"
    export SHELLRC_CURRENT_PLUGIN_DIR="${SHELLRC_CURRENT_SHELL_DIR}/${pluginName}"
    dot_if_exists "${SHELLRC_CURRENT_PLUGIN_DIR}/default.sh"
    unset SHELLRC_CURRENT_PLUGIN_DIR
}
