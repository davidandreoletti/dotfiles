#
# Pre cross shells config
#
# Import shellrc functions
. "${SHELLRC_DIR}/shellrc/functions.sh"
# Import tmux functions
. "${SHELLRC_DIR}/shellrc/tmux.sh"

# Load shell specific config
SHELLRC_STAGE0_SHELL_FILE="${SHELLRC_DIR}/${SHELL_NAME}/shellrc/stage_0.sh"
[[ -s ${SHELLRC_STAGE0_SHELL_FILE} ]] && . "${SHELLRC_STAGE0_SHELL_FILE}"

