# Start libvirt daemon for virt-manager to connect to it, if installed
(
    flock --nonblock 100 || exit 0
    brew services list | grep "libvirt" && brew services start libvirt & 
) 100> /tmp/shellrc.libvirt.lock > /dev/null & 
