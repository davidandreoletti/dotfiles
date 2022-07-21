# Upgrade https://github.com/NikolayS/postgres_dba

# Note: ~/.psqlrc hardcode postgres_dba at ~/.postgres_dba
( ( git pull --rebase ~/.postgres_dba > /dev/null 2>&1 | git clone https://github.com/NikolayS/postgres_dba ~/.postgres_dba > /dev/null 2>&1 ) & )

