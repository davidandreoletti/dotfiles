function f_libguestfs_mount_image() {
	local image="${1:-/tmp/missing.qcow2}"
	local partition="${2:-/dev/sda1}"
	local mountPoint="${3:-/tmp/${USER}_libguestfs_mount_${RANDOM}}"

	test -d "$mountPoint" ||  mkdir -p "$mountPoint"
	virt-list-partitions "$image" 
	virt-list-filesystems "$image" 
	guestmount -a "$image" -m "$partition" "$mountPoint"
}

function f_libguestfs_unmount_image() {
	local mountPoint="${1:-/tmp/${USER}_libguestfs_mount_${RANDOM}}"
	guestunmount -a "$mountPoint"
}
