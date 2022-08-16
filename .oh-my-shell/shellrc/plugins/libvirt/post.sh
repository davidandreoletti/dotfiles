# Start libvirt daemon for virt-manager to connect to it
( ( brew services start libvirt & ) > /dev/null & )
