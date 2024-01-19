#
# Disable starting livirt service on macOS since virt-manager does not work well on macOS for now
#

# Start libvirt daemon for virt-manager to connect to it, if installed
#(
#    flock --nonblock 9 || exit 0
#    brew services list | grep "libvirt" && brew services start libvirt &
#) 9>/tmp/shellrc.libvirt.lock > /dev/null &
