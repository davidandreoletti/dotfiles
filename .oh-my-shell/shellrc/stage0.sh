#
# Pre cross shells config
#
# Import shellrc functions
source "${SHELLRC_DIR}/shellrc/functions.sh"
# Import tmux functions
source "${SHELLRC_DIR}/shellrc/tmux.sh"

# Load shell specific config
SHELLRC_STAGE0_SHELL_FILE="${SHELLRC_DIR}/${SHELL_NAME}/shellrc/stage0.sh"
[[ -s ${SHELLRC_STAGE0_SHELL_FILE} ]] && source "${SHELLRC_STAGE0_SHELL_FILE}"

