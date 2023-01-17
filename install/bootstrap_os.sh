## OS environments
#
# inspired from:
# - https://github.com/dushankw/minimal-fedora-install/blob/master/bootstrap.sh
is_profile_admin_or_similar
if [ "$?" -eq 0 ];
then
    # Install and enable zram by default with default config
    # src: https://fedoraproject.org/wiki/Changes/SwapOnZRAM
    is_fedora  &&  fedora_dnf_install "zram" \
               &&  fedora_dnf_install "zram-generator" \
               &&  fedora_dnf_install "zram-generator-defaults"
fi
