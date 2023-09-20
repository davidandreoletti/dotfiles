# Run virt-manager with user session 
# as described by https://www.arthurkoziel.com/running-virt-manager-and-libvirt-on-macos/
alias virtmanager='virt-manager -c "qemu:///session" --no-fork'

# Create Ubuntu Server 20.04/22.04 VM
# Usage: virt_create_vm_ubuntu2204 --name "test" --memory "1024" --vcpus "2" --osinfo ubuntujammy --cloud-init user-data=/path/to/cloud-config/file
# Usage (dev mode): LIBVIRT_POOL_LOCAL_SETUP_DEV=1 virt_create_vm_ubuntu2204 --name "test" --memory "1024" --vcpus "2" --osinfo ubuntujammy --cloud-init user-data=/path/to/cloud-config/file
alias virt_create_vm_ubuntu2204='f_libvirt_domain_setup_ubuntu_2204 virt_install'
alias virt_create_vm_ubuntu2004='f_libvirt_domain_setup_ubuntu_2004 virt_install'

# Create Ubuntu 20.04/22.04 VM
# Usage: virt_create_vm_ubuntu2204_legacy "domain_name" 0 "tcp::2222-:22"
# 0: ubuntu desktop live os
# 1: ubuntu server permanent os
alias virt_create_vm_ubuntu2204_legacy='f_libvirt_domain_setup_ubuntu_2204 manual_install'
alias virt_create_vm_ubuntu2004_legacy='f_libvirt_domain_setup_ubuntu_2004 manual_install'

# Create a new VM in a new pool
# Usage: virtNewVM "domain_name"
alias virt_start_vm='f_libvirt_domain_start '

# Wipe out a VM in a new pool
# Usage: wipeVM "domain_name"
alias virt_delete_vm='f_libvirt_domain_unsetup '

# Start vm from menu
# Usage: virt_start_vm_menu
alias virt_start_vm_menu='virsh list --all --name | grep "-" | fzf | xargs -I% virsh start %'
