#
# Bootstrap cross shells config
#
# Import shellrc functions
. "${SHELLRC_SHELLRC_DIR}/functions.sh"
# Import tmux functions
. "${SHELLRC_SHELLRC_DIR}/tmux.sh"

SHELL_NAME=`get_shell_type`
SHELLRC_CURRENT_SHELL_DIR="${SHELLRC_DIR}/${SHELL_NAME}"

# Load shell specific config
SHELLRC_BOOTSTRAP_SHELL_FILE="${SHELLRC_CURRENT_SHELL_DIR}/boostrap.sh"
[[ -s ${SHELLRC_BOOTSTRAP_SHELL_FILE} ]] && . "${SHELLRC_BOOTSTRAP_SHELL_FILE}"

