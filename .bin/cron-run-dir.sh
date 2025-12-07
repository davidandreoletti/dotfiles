CRON_RUN_DIR="$1"

for script_file in $CRON_RUN_DIR/*.sh;
do
    if test -f "$script_file"; then
        CRON_SCRIPT_LOG_FILE="/tmp/cron/$CRON_RUN_DIR/$(basename $script_file)"
        mkdir -p "$(dirname $CRON_SCRIPT_LOG_FILE)"

        sh -x "$script_file" > "$CRON_SCRIPT_LOG_FILE" 2>&1
        echo "EXIT CODE: $?" >> "$CRON_SCRIPT_LOG_FILE"
    fi
done
