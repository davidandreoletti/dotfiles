# Start libvirt daemon for virt-manager to connect to it, if installed
( ( brew services list | grep "libvirt" && brew services start libvirt & ) > /dev/null & )
