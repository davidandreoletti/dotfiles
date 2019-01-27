#
# Custom cross shell config
#
#

# Load homebrew config 
. "${SHELLRC_DIR}/shellrc/homebrew.sh"
# Load ssh config 
. "${SHELLRC_DIR}/shellrc/ssh.sh"
# Load java config
. "${SHELLRC_DIR}/shellrc/java.sh"
# Load nvm config
. "${SHELLRC_DIR}/shellrc/nvm.sh"
# Load npm config
. "${SHELLRC_DIR}/shellrc/npm.sh"
# Load python config
. "${SHELLRC_DIR}/shellrc/python.sh"

# Load shell specific config
SHELLRC_STAGE_CUSTOM_SHELL_FILE="${SHELLRC_DIR}/${SHELL_NAME}/shellrc/stage_custom.sh"
[[ -s ${SHELLRC_STAGE_CUSTOM_SHELL_FILE} ]] && . "${SHELLRC_STAGE_CUSTOM_SHELL_FILE}"

# Load computer shell specific config
SHELLRC_STAGE_CUSTOM_SHELL_FILE="${HOME}/.shellrc_stage_custom.sh"
[[ -s ${SHELLRC_STAGE_CUSTOM_SHELL_FILE} ]] && . "${SHELLRC_STAGE_CUSTOM_SHELL_FILE}"
