function f_code_create_company_workspace_project() {
    local code_dir="$1"
    local company="$(echo $2 | tr '[:lower:]' '[:upper:]')"
    local workspace="$(echo $3 | tr '[:lower:]' '[:upper:]')_WORKSPACE"
    local project="$(echo $4 | tr '[:lower:]' '[:upper:]')"

    mkdir -p "${code_dir}/$company/$workspace/$project"
}
