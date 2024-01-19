# Print current umask in various format
# usage: f_unixpermission_umask 077
# src: https://unix.stackexchange.com/a/465487/45954
f_unixpermission_display_umask() (
    umask -S
    umask
)
