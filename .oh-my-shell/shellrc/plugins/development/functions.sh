f_code_create_company_workspace_project() {
    local code_dir="$1"
    local company="$(echo $2 | tr '[:lower:]' '[:upper:]')"
    local workspace="$(echo $3 | tr '[:lower:]' '[:upper:]')_WORKSPACE"
    local project="$(echo $4 | tr '[:lower:]' '[:upper:]')"

    mkdir -p "${code_dir}/$company/$workspace/$project"
}

# POSIX-compatible script to delete everything below folders
# ending with *_WORKSPACE
f_code_wipe_workspace() {
    # Starting directory (default: current directory)
    local start_dir="$1" 

    start_dir="$(realpath "$start_dir")"

    # Find matching directories
    workspace_dir="$(find "$start_dir" -maxdepth 1 -type d -name '*_WORKSPACE' -printf '%P\n' | fzf)"

    echo "Confirm wiping $workspace_dir ? [y/n]"
    workspace_dir="$start_dir/$workspace_dir"
    read answer

    case "$answer" in
        [Yy]) 
            command rm -rf "$workspace_dir"
            ;;
        *)
            echo "Aborted."
            ;;
    esac
}

