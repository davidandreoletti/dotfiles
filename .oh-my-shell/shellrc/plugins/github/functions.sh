# Usage: f_github_clone_all_repos "orgs" "organizationName" "GITHUB_PERSONAL_ACCESS_TOKEN"
# Usage: f_github_clone_all_repos "users" "userName" "GITHUB_PERSONAL_ACCESS_TOKEN"
function f_github_clone_all_repos () {
    local CNTX="$1"; 
    local NAME="$2"; 
    local GITHUB_API_TOKEN="$3";
    PAGE=1
    curl "https://api.github.com/$CNTX/$NAME/repos?access_token=$GITHUB_API_TOKEN&per_page=1000" | grep -o 'git@[^"]*' | xargs -I _ -P4 -L1 git clone
}
