#!/bin/bash
#
# Requires: xmllint, libvirt, xmlstarlet

#shellcheck disable=SC2034
LIBVIRT_POOL_MANUAL_ROOT_DIR="$HOME/Documents/VirtualMachines/libvirt"
#shellcheck disable=SC1007
LIBVIRT_THIS_PLUGIN_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
export LIBVIRT_DEFAULT_URI="qemu:///session"

function f_libvirt_pool_local_setup {
    local poolName="$1"
    local poolPath="$2"
    local poolType="dir"

    if [[ "$poolPath" == "default" ]];
    then
        poolPath="$LIBVIRT_POOL_MANUAL_DEFAULT_DIR/$poolName"
    fi

    echo "Creating pool ..."
    #shellcheck disable=SC2086
    virsh ${VIRSH_OPTIONS} pool-define-as \
            --name "$poolName" \
            --type "$poolType" \
            --target "$poolPath" \
        && virsh ${VIRSH_OPTIONS} pool-build \
            --pool "$poolName" \
        && virsh ${VIRSH_OPTIONS} pool-start \
            --pool "$poolName" \
        && virsh ${VIRSH_OPTIONS} pool-autostart \
            --pool "$poolName" \
        && virsh ${VIRSH_OPTIONS} pool-refresh \
            --pool "$poolName" \
        && virsh ${VIRSH_OPTIONS} pool-info \
            --pool "$poolName"
}

function f_libvirt_pool_volume_disk_define {
    local poolName="$1"
    local volName="$2"
    local volFormat="$3"
    local volSize="$4"

    #shellcheck disable=SC2086,SC2155
    local poolPath="$(virsh pool-dumpxml --pool $poolName --xpath '//pool/target/path/text()')"

    local srcFile="$poolPath/$volName.final"
    local dstFile="$poolPath/$volName"

    #shellcheck disable=SC2086
    qemu-img create -f $volFormat \
        -o extended_l2=on,cluster_size=128k,preallocation=metadata,compat=1.1 \
        "$srcFile" $volSize

    #shellcheck disable=SC2086
    if virsh ${VIRSH_OPTIONS} --pool "$poolName" "$volName" >/dev/null 2>&1;
    then
        echo "$volName does not exist yet"
    else
        virsh ${VIRSH_OPTIONS} vol-delete \
            --pool "$poolName" \
            --vol "$volName"
    fi

    #shellcheck disable=SC2086
    virsh ${VIRSH_OPTIONS} vol-create-as \
        --pool "$poolName" \
        --name "$volName" \
        --capacity "$volSize" \
        --format "$volFormat"

    mv "$srcFile" "$dstFile"
}

function f_libvirt_pool_volume_cdrom_define {
    local poolName="$1"
    local volName="$2"

    #shellcheck disable=SC2086,SC2155
    local poolPath="$(virsh pool-dumpxml --pool $poolName --xpath '//pool/target/path/text()')"

    local srcFile="$poolPath/$volName.final"
    local dstFile="$poolPath/$volName"

    #shellcheck disable=SC2086
    virsh ${VIRSH_OPTIONS} vol-delete \
        --pool "$poolName" \
        --vol "$volName"

    #shellcheck disable=SC2086
    virsh ${VIRSH_OPTIONS} vol-create-as \
        --pool "$poolName" \
        --name "$volName" \
        --capacity "700M" \
        --format "raw"
}
 
 

function f_libvirt_domain_start {
    local domainName="$1"

    #shellcheck disable=SC2086
    virsh ${VIRSH_OPTIONS} start \
        --domain "$domainName"

    # VNC access: https://www.cyberciti.biz/faq/linux-kvm-vnc-for-guest-machine/
    #shellcheck disable=SC2086
    vncURL="vnc://localhost$(virsh ${VIRSH_OPTIONS} vncdisplay --domain $domainName)"
    # FIXME: Deal with non ubuntu os later
    sshURL="ssh ubuntu@localhost -p 222x"
    consoleURL="virsh console $domainName + ENTER + type user login's password"

    echo "Access methods:"
    echo "VNC: $vncURL"
    echo "Console: $consoleURL"
    echo "SSH(maybe): $sshURL"
}


function f_libvirt_domain_define {
    local domainName="$1"
    local domainXMLFile="$2"

    echo "Current domains:"
    #shellcheck disable=SC2086
    virsh ${VIRSH_OPTIONS} list \
        --all

    echo "QEMU CLI equivalent:"
    #shellcheck disable=SC2086
    virsh ${VIRSH_OPTIONS} domxml-to-native \
        qemu-argv --xml "$domainXMLFile"

    echo "(Re)defining domain ..."
    #shellcheck disable=SC2086
    virsh ${VIRSH_OPTIONS} destroy \
        "$domainXMLFile"
 
    #shellcheck disable=SC2086
    virsh ${VIRSH_OPTIONS} undefine \
        --nvram \
        "$domainXMLFile"
    
    #shellcheck disable=SC2086
    virsh ${VIRSH_OPTIONS} define \
            --file "$domainXMLFile" \
        && virsh ${VIRSH_OPTIONS} dumpxml "$domainName" \
        && virsh ${VIRSH_OPTIONS} domuuid "$domainName"
}

function f_libvirt_domain_setup {
    local poolName="$1"
    local poolPath="$2"
    local domainXMLFile="$3"
    #shellcheck disable=SC2155,SC2086
    local domainName="$(xmllint --xpath '//domain/name/text()' $domainXMLFile)"

    f_libvirt_pool_local_setup "$poolName" "$poolPath" \
        && f_libvirt_pool_volume_disk_define "$poolName" "disk-os" "qcow2" "20G" \
        && f_libvirt_pool_volume_disk_define "$poolName" "disk-data0" "qcow2" "50G" \
        && f_libvirt_pool_volume_cdrom_define "$poolName" "disk-cdrom" \
        && f_libvirt_domain_define "$domainName" "$domainXMLFile"
}

function f_libvirt_domain_setup_simple {
    local domainName="$1"
    local domainXMLDir="$2"
    local domainTemplateXMLFile="$3"
    local vcpu="$4"
    local memory="$5"
    local hostForward="$6"

    # Duplicate template and edit it
    local domainXMLFile="$domainXMLDir/${domainName}.xml"
    mkdir -p "$domainXMLDir"
    xmlstarlet ed -u "//domain/name" -v "$domainName" "$domainTemplateXMLFile" > "$domainXMLFile"
    sed -i "s/__VCPU__/$vcpu/g" "$domainXMLFile"
    sed -i "s/__MEMORY__/$memory/g" "$domainXMLFile"
    sed -i "s/__HOSTFWD__/$hostForward/g" "$domainXMLFile"
    sed -i "s/__POOLNAME__/$domainName/g" "$domainXMLFile"

    #shellcheck disable=SC2155,SC2086
    local domainName="$(xmllint --xpath '//domain/name/text()' $domainXMLFile)"

    #shellcheck disable=SC2155,SC2086
    local poolName="$domainName"
    #shellcheck disable=SC2155,SC2086
    local poolPath="$(dirname $domainXMLFile)"

    f_libvirt_domain_setup "$poolName" "$poolPath" "$domainXMLFile"
}

function f_libvirt_domain_unsetup {
    local domainName="$1"

    echo "Unsetup domain ..."
    #shellcheck disable=SC2086
    virsh ${VIRSH_OPTIONS} pool-destroy "$domainName"
    #shellcheck disable=SC2086
    virsh ${VIRSH_OPTIONS} pool-undefine "$domainName"
    #shellcheck disable=SC2086
    virsh ${VIRSH_OPTIONS} destroy "$domainName"
    #shellcheck disable=SC2086
    virsh ${VIRSH_OPTIONS} undefine \
        --remove-all-storage \
        --delete-storage-volume-snapshots \
        --snapshots-metadata \
        --nvram \
        "$domainName"
}


function f_libvirt_domain_setup_ubuntu_generic {
    local releaseName="$1"
    local domainName="$2"
    local desktopMode="${3:-1}"
    #Note: Don't use image with suffix '-kvm.img'. These don't boot
    #eg: "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
    local imgURL="$4"
    local imgLiveCDURL="$5"
    local hostForward="$6"

    local imgOSOriginalFile="/tmp/$$.${releaseName}.server.ubuntu.amd64.img"
    local imgOSLiveOriginalFile="/tmp/$$.${releaseName}.desktop.ubuntu.amd64.iso"
    local imgSeedFile="${imgOSOriginalFile}.seed.img"
    local imgFile="${imgOSOriginalFile}.qcow2"
    local userDataFile="${imgFile}.user_data"
    local metaDataFile="${imgFile}.meta_data"
    local containerTag="ubuntu-cloud-image-utils"

    # Customize Ubuntu OS disk via cloud-init
    # src: https://cloudinit.readthedocs.io/en/latest/topics/examples.html#yaml-examples
    # https://askubuntu.com/a/1081171/226227
    # cloud-init options: https://cloudinit.readthedocs.io/en/latest/topics/modules.html

cat > "$userDataFile" <<EOF
#cloud-config
password: ubuntu
chpasswd: { expire: False }
ssh_pwauth: true
EOF

    echo "instance-id: $(uuidgen || echo i-abcdefg)" > "$metaDataFile"

    if [[ "$desktopMode" == "0" ]];
    then
        wget --no-timestamping -O "$imgOSLiveOriginalFile" -nc "$imgLiveCDURL"
        vcpu=4
        memory=4
    else
        wget --no-timestamping -O "$imgOSOriginalFile" -nc "$imgURL"
        vcpu=2
        memory=2
    fi

    # Build + run cloud-locals to generate seed.img containing cloud-config settings
    docker build . \
        -t "$containerTag" \
        -f "$LIBVIRT_THIS_PLUGIN_DIR/image-builder/ubuntu/Dockerfile"

    # Create missing file + generate seed.img
    # Note: docker mount missing file: https://stackoverflow.com/a/54243080/219728
    touch "$imgSeedFile"
    docker run \
        -t \
        --rm \
        --mount type=bind,source="${imgSeedFile}",target="/mnt/seed.img" \
        --mount type=bind,source="${userDataFile}",target="/mnt/user_data" \
        --mount type=bind,source="${metaDataFile}",target="/mnt/meta_data" \
        "$containerTag" \
        cloud-localds -v /mnt/seed.img /mnt/user_data /mnt/meta_data

    # Create VM
    local domainXMLTemplateFile="$LIBVIRT_THIS_PLUGIN_DIR/image-builder/ubuntu/domain-template.xml"
    local domainXMLDir="$PWD/${domainName}"
    f_libvirt_domain_setup_simple "$domainName" "$domainXMLDir" "$domainXMLTemplateFile" "$vcpu" "$memory" "$hostForward"

    # Copy os + seed disks
    [ -f "$imgOSOriginalFile" ] && cp "$imgOSOriginalFile" "$domainXMLDir/disk-os" && qemu-img resize "$domainXMLDir/disk-os" +20G
    [ -f "$imgSeedFile" ] && cp "$imgSeedFile" "$domainXMLDir/disk-seed"
    [ -f "$imgOSLiveOriginalFile" ] && [[ "$desktopMode" == "0" ]] && cp "$imgOSLiveOriginalFile" "$domainXMLDir/disk-cdrom"
}


function f_libvirt_domain_setup_ubuntu_2204 {
    local domainName="$1"
    local desktopMode="$2"
    local hostForward="$3"

    f_libvirt_domain_setup_ubuntu_generic \
        "jammy" \
        "$domainName" \
        "$desktopMode" \
        "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img" \
        "https://releases.ubuntu.com/22.04/ubuntu-22.04.1-desktop-amd64.iso" \
        "$hostForward"
}


function f_libvirt_domain_setup_ubuntu_2004 {
    local domainName="$1"
    local desktopMode="$2"
    local hostForward="$3"

    f_libvirt_domain_setup_ubuntu_generic \
        "focal" \
        "$domainName" \
        "$desktopMode" \
        "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img" \
        "https://releases.ubuntu.com/20.04/ubuntu-20.04.5-desktop-amd64.iso" \
        "$hostForward"
}
