# Run virt-manager with user session 
# as described by https://www.arthurkoziel.com/running-virt-manager-and-libvirt-on-macos/
alias virtmanager='virt-manager -c "qemu:///session" --no-fork'

# Create a new VM in a new pool
# Usage: virtNewVM "domain_name" "/path/to/domain-template.xml"
alias virtCreateVM='f_libvirt_domain_setup_simple '

# Create Ubuntu 20.04/22.04 VM
# Usage: virtNewVMUbuntu2204 "domain_name" 0 "tcp::2222-:22"
# 0: ubuntu desktop live os
# 1: ubuntu server permanent os
alias virtCreateVMUbuntu2204='f_libvirt_domain_setup_ubuntu_2204 '
alias virtCreateVMUbuntu2004='f_libvirt_domain_setup_ubuntu_2004 '

# Create a new VM in a new pool
# Usage: virtNewVM "domain_name"
alias virtStartVM='f_libvirt_domain_start '

# Wipe out a VM in a new pool
# Usage: wipeVM "domain_name"
alias virtDeleteVM='f_libvirt_domain_unsetup '

