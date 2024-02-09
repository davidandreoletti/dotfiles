# Install daemons/applications/processes/scripts on macOS(launchctl)
# https://www.launchd.info

if is_macos; then
    target_dir="$HOME/Library/LaunchAgents"

    launch_dir="$HOME/.config/launch"
    for job in $launch_dir/*.plist; do
        job_file="$(basename $job)"

        job_file2="$(echo "$job_file" | sed "s/__USER__/$USER/g")"
        job_new="$launch_dir/$job_file2"
        sed "s/__USER__/$USER/g" "$job" > "$job_new"
        job="$job_new"
        job_file="$job_file2"

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
            # use short options for macOS's ln
            command rsync "$job" "$target_job"
        fi

        for j in "$target_job";
        do
            if ! test -s "$j"; then
                echo "warn:launchd $j is missing OR empty"
                continue
            fi
        done

        # Verify job is well formed
        # - plutil requries a file rather than symlink
        if ! plutil -lint "$(realpath $target_job)" >/dev/null 2>&1 ; then
            break
        fi

        # Permanently enable job to launch at login, even if disabled
        # Load job
        #old syntax:launchctl load -w -F "$target_job"
        if launchctl list | grep "$job_name" >/dev/null 2>&1; then
            launchctl bootout gui/$(id -u) "$target_job"
        fi
        launchctl bootstrap gui/$(id -u) "$target_job"

        # Run job immediately
        launchctl start "$job_name"

        # Check job is launched
        if ! launchctl list | grep "$job_name" >/dev/null 2>&1; then
            echo "warn:launchd $job_name not loaded/started"
        fi
    done
fi
