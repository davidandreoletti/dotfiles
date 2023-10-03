alias code="cd ${_DEFAULT_DEVELOPMENT_DIR}"
alias code_menu="cd \"${_DEFAULT_DEVELOPMENT_DIR}/\$(find ${_DEFAULT_DEVELOPMENT_DIR} -maxdepth 3 -type d -name '*.git' -printf '%P\n' | fzf)\" "
