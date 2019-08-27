export GIT_ALIASES_COM_FILE="$HOME/.config/git/aliases/gitaliases"

AGE=2678400  # 31 days * 24h * 3600s
# Update file if not present OR older than $AGE
( [ ! -f "$GIT_ALIASES_COM_FILE" ] || [ `stat --format=%Y "$GIT_ALIASES_COM_FILE"` -le $(( `date +%s` - $AGE )) ] ) && \
    curl --silent "https://raw.githubusercontent.com/GitAlias/gitalias/master/gitalias.txt" -o "$GIT_ALIASES_COM_FILE"
