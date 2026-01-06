if is_macos; then
    edit_qemu_conf_property() {
        local file_path="$1"
        local prop_name="$2"
        local prop_value="$3"

        if ! egrep -i "^${prop_name} =.*" "$file_path"; then
            sudo sed -i "s/#${prop_name} = .*/${prop_name} = ${prop_value}/g" "$conf_file"
        fi
    }

    conf_file="$(brew --prefix)/etc/libvirt/qemu.conf"
    if test -f "$conf_file"; then
        edit_qemu_conf_property "$conf_file" "user" "root"
        edit_qemu_conf_property "$conf_file" "group" "root"
        # Drop unsuuported features on macOS
        # - https://www.naut.ca/blog/2020/08/26/ubuntu-vm-on-macos-with-libvirt-qemu/
        # -- https://gitlab.com/libvirt/libvirt/-/issues/241
        edit_qemu_conf_property "$conf_file" "security_driver" "none"
        edit_qemu_conf_property "$conf_file" "dynamic_ownership" "0"
        edit_qemu_conf_property "$conf_file" "remember_owner" "0"
        # FIXME: Networking:
        #   - https://gist.github.com/davidandreoletti/af2a17ea095af9476ad012b4a2365a40
        #   - https://gitlab.com/libvirt/libvirt/-/issues/75
    fi
fi
