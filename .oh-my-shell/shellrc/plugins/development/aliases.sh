# Move shell working dir to default development dir
# usage: code
alias code="cd ${_DEFAULT_DEVELOPMENT_DIR}"

# Move shell working dir to a user select git directory within the default development dir
# usage: tcode
alias tcode="cd \"${_DEFAULT_DEVELOPMENT_DIR}/\$(find ${_DEFAULT_DEVELOPMENT_DIR} -maxdepth 3 -type d -name '*.git' -printf '%P\n' | grep -v '.git/.git' | fzf)\" "

# Create workspace
# Usage: code_create_company_workspace_project "company_name" "workspace_name" "project_name"
alias code_create_workspace="f_code_create_workspace ${_DEFAULT_DEVELOPMENT_DIR} "
