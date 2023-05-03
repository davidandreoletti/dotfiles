# Start libvirt daemon for virt-manager to connect to it, if installed
(
    flock --nonblock 9 || exit 0
    brew services list | grep "libvirt" && brew services start libvirt & 
) 9>/tmp/shellrc.libvirt.lock > /dev/null & 
