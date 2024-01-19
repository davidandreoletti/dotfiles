# FIXME Discard run if not macos

# Install daemons/applications/processes/scripts on macOS(launchctl)
# https://www.launchd.info

target_dir="$HOME/Library/LaunchAgents"

for job in $HOME/.config/launch/*.plist; do
    job_file="$(basename $job)"
    job_name="$(echo $job_file | sed -E 's/(.*?)\..*/\1/')"

    target_job="$target_dir/$job_file"

    if [ ! -d "$target_dir" ]; then
        # Most likely not on the relevant platfrom
        continue
    fi

    # Link job to user agent location
    if [ -e "$target_job" ]; then
        # target job exist and linked to local job file
        continue
    fi

    command ln --symbolic --force "$job" "$target_job"

    # Permanently enable job to launch at login
    launchctl load "$target_job"

    # Run job immediately
    launchctl start "$job_name"
done
