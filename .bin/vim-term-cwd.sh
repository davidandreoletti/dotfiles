# Execute shell with current dir as provided by vim
found=1
for envBin in "/usr/local/opt/coreutils/libexec/gnubin/env"; do
    if test -x "$envBin"; then
        # Found GNU env binary.

        # Current shell replaced with the following command
        dir="$1"
        exec $envBin --chdir "$dir" zsh
    fi
done

# No env program found
test $found -eq 1 && exit 1
