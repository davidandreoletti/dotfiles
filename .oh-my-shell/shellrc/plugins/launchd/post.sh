# Install daemons/applications/processes/scripts on macOS(launchctl)
# https://www.launchd.info

if test -n "$PLUGIN_LAUNCHD_POST_PLIST"; then
    PLISTS="$PLUGIN_LAUNCHD_POST_PLIST"
else
    PLISTS="*.plist"
fi

if test -n "$PLUGIN_LAUNCHD_POST_WAIT_DURATION"; then
    WAIT_DURATION="$PLUGIN_LAUNCHD_POST_WAIT_DURATION"
else
    WAIT_DURATION="0"
fi

if is_macos; then
    target_dir="$HOME/Library/LaunchAgents"
    launch_dir="$HOME/.config/launch"

    for job in $(find "$launch_dir/" -maxdepth 1 -name "$PLISTS"); do
        job_file="$(basename $job)"

        # Generate file name for template based jobs
        job_file2="$(echo "$job_file" | sed "s/__USER__/$USER/g")"

        # Check if template based job
        test "$job_file" != "$job_file2";
        templated=$?

        # Fill template
        if test $templated -eq 0; then
            # Template launchd job
            job_new="$launch_dir/$job_file2"
            sed "s/__USER__/$USER/g" "$job" > "$job_new"
            job="$job_new"
            job_file="$job_file2"
        fi

        job_name="$(echo $job_file | sed -E 's/\.plist//')"
        target_job="$target_dir/$job_file"

        if ! test -d "$target_dir"; then
            # Most likely not on the relevant platfrom
            continue
        fi

        # Link job to user agent location
        if test -e "$target_job"; then
            # target job exist 
            :
            # Job exist but definition possibly outdated. 
            # - Consider not waiting at all
            WAIT_DURATION=0
        else
            # use short options for macOS's ln
            command rsync "$job" "$target_job"
        fi

        # Remove template from local dir
        if test $templated -eq 0; then
            command rm "$job"
        fi

        # Verify target_job is not empty for some random reason
        if ! test -s "$target_job"; then
            echo "warn:launchd $target_job is missing OR empty"
            continue
        fi

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

        until false; do
            # Run job immediately
            launchctl start "$job_name"

            # Wait for job (in seconds)
            command sleep ${WAIT_DURATION}

            # Check job is launched
            if ! launchctl list | grep "$job_name" >/dev/null 2>&1; then
                echo "warn:launchd $job_name not loaded/started"
            else
                break
            fi
        done
    done
fi
