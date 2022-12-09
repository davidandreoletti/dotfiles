function f_gdb_codesign_on_macos {
    # src: https://sourceware.org/gdb/wiki/PermissionsDarwin#Sign_and_entitle_the_gdb_binary
    set -x 
    local gdbBin="$1"

    tmpDir="/tmp/gdb_codesign_$RANDOM"
    mkdir $tmpDir 
    pushd $tmpDir
        # Create + Trust certificate in the System Keychain
        wget https://raw.githubusercontent.com/conda-forge/gdb-feedstock/main/recipe/macos-codesign/macos-setup-codesign.sh
        bash macos-setup-codesign.sh

        # Verify certificate not expired (for old certifiacte install)
        security find-certificate -p -c gdb-cert | openssl x509 -checkend 0 || exit 1

        # Sign and entitle the gdb binary
command cat << EOF > gdb-entitlement.xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.cs.debugger</key>
    <true/>
</dict>
</plist>
EOF
        codesign --entitlements gdb-entitlement.xml -fs gdb_codesign "$gdbBin"

        # verify gdb binary is signed
        codesign -vv "$gdbBin"
        codesign -d --entitlements :- "$gdbBin"

        echo "Now RESTART taskgated as follow:"
        echo "- sudo killall taskgated"
        echo '- check taskgated restarted with ps $(pgrep -f taskgated)'
    popd
}
