#
# Bootstrap cross shells config
#
# Import shellrc functions
. "${SHELLRC_DIR}/shellrc/functions.sh"
# Import tmux functions
. "${SHELLRC_DIR}/shellrc/tmux.sh"

SHELL_NAME=`get_shell_type`

# Load shell specific config
SHELLRC_BOOTSTRAP_SHELL_FILE="${SHELLRC_DIR}/${SHELL_NAME}/shellrc/boostrap.sh"
[[ -s ${SHELLRC_BOOTSTRAP_SHELL_FILE} ]] && . "${SHELLRC_BOOTSTRAP_SHELL_FILE}"

