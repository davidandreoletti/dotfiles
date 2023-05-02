# Upgrade https://github.com/NikolayS/postgres_dba
POSTGRES_DBA_GIT_DIR="$HOME/.postgres_dba"
# Note: ~/.psqlrc hardcode postgres_dba at ~/.postgres_dba
( ( git -C "$POSTGRES_DBA_GIT_DIR" pull --rebase > /dev/null 2>&1 || git clone https://github.com/NikolayS/postgres_dba "$POSTGRES_DBA_GIT_DIR" > /dev/null 2>&1 ) & )

