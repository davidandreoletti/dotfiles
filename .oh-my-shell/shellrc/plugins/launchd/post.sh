# Install daemons/applications/processes/scripts on macOS(launchctl)
# https://www.launchd.info

if is_macos; then
    target_dir="$HOME/Library/LaunchAgents"

    for job in $HOME/.config/launch/*.plist; do
        job_file="$(basename $job)"
        job_name="$(echo $job_file | sed -E 's/\.plist//')"

        target_job="$target_dir/$job_file"

        if ! test -d "$target_dir"; then
            # Most likely not on the relevant platfrom
            continue
        fi

        # Link job to user agent location
        if test -e "$target_job"; then
            # target job exist and linked to local job file
            :
        else
            command ln --symbolic --force "$job" "$target_job"
        fi

        # Permanently enable job to launch at login, even if disabled
        launchctl load -w "$target_job"

        # Load job, even if disabled
        launchctl load -F "$target_job"

        # Run job immediately
        launchctl start "$job_name"

        launchctl list 
    done
fi
