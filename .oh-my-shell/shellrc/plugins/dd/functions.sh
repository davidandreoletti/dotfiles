f_dd_verify() {
    #echo "This is not working as expected yet"
    #return 1

    # - Shell posix compatible dd with hash input+output verification
    # - no write to disk for non input/output data
    local input="$1"
    local output="$2"
    local compression="${3:-none}"
    local bs="${4:-4M}"
    local buffer="${5:-8m}"

    # Detect if input is compressed
    file $input | grep "compressed"
    # compressed=0 -> file is compressed
    compressed="${PIPESTATUS}${pipestatus}" # bash/zsh

    local catBin="ucat"
    if [ "$compressed" = "0 1" ]; then
        catBin="cat"
    fi

    echo "dd'ing: $input -> $output ..."
    FIFO0="/tmp/$$.dd_to_disk.0"
    FIFO1="/tmp/$$.dd_to_disk.1"
    FIFO2="/tmp/$$.dd_to_disk.2"
    FIFO3="/tmp/$$.dd_to_disk.3"
    FIFOS="/tmp/$$.dd_to_disk.size"
    FIFOH="/tmp/$$.dd_to_disk.hash"

    command rm -f $FIFO0
    command rm -f $FIFO1
    command rm -f $FIFO2
    command rm -f $FIFO3
    command rm -f $FIFOS
    command rm -f $FIFOH

    mkfifo $FIFO0
    mkfifo $FIFO1
    mkfifo $FIFO2
    mkfifo $FIFO3

    local catPID
    local ucatPID
    local hashPID
    local ddPID
    local sizePID
    local compressPID

    local hash
    local hash2

    local ddJID

    #
    # Pre-warm sudo
    #
    sudo true

    #
    #Write to multiple FIFO files
    #

    input_sudo=''
    if test -b "$input" || test -c "$input"; then
        input_sudo='sudo'
    fi

    output_sudo=''
    if test -b "$output" || test -c "$output"; then
        output_sudo='sudo'
    fi

    # Use pee instead of tee, to prevent tee from getting stuck randomly on macOS
    #command $catBin "$input" | env tee -p $FIFO0 | env tee -p $FIFO1 > $FIFO2 &
    ($input_sudo command $catBin "$input" | pee "cat > $FIFO0" "cat > $FIFO1" "cat > $FIFO2") >/dev/null 2>&1 &
    ucatPID=$!

    #
    # Read from each FIFO individually
    #
    # (a | b |c ) 1>/dev/null 2>&1 & ==> put pipe in background, redirect stdout to /dev/null, redirect stderr to /dev/null too
    (command cat $FIFO1 | command pv --progress --rate --bytes --wait --buffer-size $buffer --name "sha256sum" | command sha256sum >$FIFOH) 1>/dev/null 2>&1 &
    hashPID=$!

    (command cat $FIFO0 | command pv --progress --rate --bytes --wait --buffer-size $buffer --name "wc" | wc --bytes --total=only >$FIFOS) 1>/dev/null 2>&1 &
    catPID=$!

    FIFOLAST="$FIFO2"
    compressPID=$catPID
    if test "$compression" = "zstd"; then
        (cat $FIFOLAST | zstd -z -c -f -q | command pv --progress --rate --bytes --wait --buffer-size $buffer --name "compression" > $FIFO3) 1>/dev/null 2>&1 &
        compressPID=$!
        FIFOLAST="$FIFO3"
    fi

    # Write to output
    command cat $FIFOLAST | command pv --progress --rate --bytes --wait --buffer-size $buffer --name "writing $output" --force | $output_sudo command dd of="$output" bs=$bs status=none

    #
    # Wait for all FIFO to be closed
    #
    for pid in $ucatPID $hashPID $catPID $compressPID; do
        wait $pid
        code=$?

        if [ $code != 0 ]; then
            echo "copy failed. exit code: $code."
            return $code
        fi
    done

    #
    # Read total bytes written
    #
    sizeWrittenBytes=$(command cat $FIFOS)
    #echo "input size written: $sizeWrittenBytes bytes"

    command rm -f $FIFO0
    command rm -f $FIFO1
    command rm -f $FIFO2
    command rm -f $FIFO3
    command rm -f $FIFOS

    echo "verify: $input == $output ..."

    #
    # Pre-warm sudo again
    #
    sudo true

    #
    # Read input hash
    #
    hash="$(command cat $FIFOH)"

    #
    # Compute + read output hash
    #
    
    command rm -f $FIFO0
    mkfifo $FIFO0

    FIFOFIRST="$output"
    if test "$compression" != "none"; then
        ($output_sudo command ucat "$output" > "$FIFO0") 1>/dev/null 2>&1 &
        ucatPID=$!
        FIFOFIRST="$FIFO0"
    fi

    $output_sudo command dd if="$FIFOFIRST" bs=$bs status=none | pv --progress --rate --bytes --wait --buffer-size $buffer --stop-at-size --size $sizeWrittenBytes --name "verification" | sha256sum >$FIFOH
    hash2="$(command cat $FIFOH)"

    command rm -f $FIFOH

    if [ "$hash" != "$hash2" ]; then
        echo "verification: failed."
        return 1
    else
        echo "verification: OK"
    fi
}
