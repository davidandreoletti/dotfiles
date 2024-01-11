f_dd_verify() {
    #echo "This is not working as expected yet"
    #return 1

    # - Shell posix compatible dd with hash input+output verification
    # - no write to disk for non input/output data
   local input="$1"
   local output="$2"
   local bs="${3:-4M}"
   local buffer="${3:-8m}"

   file $input | grep "compressed"
   # compressed=0 -> file is compressed
   compressed="${PIPESTATUS}${pipestatus}" # bash/zsh

   local catBin="ucat"
   if [ "$compressed" = "0 1" ];
   then
       catBin="cat"
   fi

   echo "dd'ing: $input -> $output ..."
   FIFO0="/tmp/$$.dd_to_disk.0"
   FIFO1="/tmp/$$.dd_to_disk.1"
   FIFO2="/tmp/$$.dd_to_disk.2"
   FIFOS="/tmp/$$.dd_to_disk.size"
   FIFOH="/tmp/$$.dd_to_disk.hash"

   command rm -f $FIFO0
   command rm -f $FIFO1
   command rm -f $FIFO2
   command rm -f $FIFOS
   command rm -f $FIFOH

   mkfifo $FIFO0
   mkfifo $FIFO1
   mkfifo $FIFO2

   local catPID
   local ucatPID
   local hashPID 
   local ddPID 
   local sizePID 

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

   # Use pee instead of tee, to prevent tee from getting stuck randomly on macOS
   #command $catBin "$input" | env tee -p $FIFO0 | env tee -p $FIFO1 > $FIFO2 &
   (command $catBin "$input" | pee "cat > $FIFO0" "cat > $FIFO1" "cat > $FIFO2") > /dev/null 2>&1 &
   ucatPID=$!

   #
   # Read from each FIFO individually
   #
   # (a | b |c ) 1>/dev/null 2>&1 & ==> put pipe in background, redirect stdout to /dev/null, redirect stderr to /dev/null too
   (command cat $FIFO1 | command pv --progress --rate --bytes --wait --buffer-size $buffer --name "sha256sum" | command sha256sum > $FIFOH) 1>/dev/null 2>&1 &
   hashPID=$!

   (command cat $FIFO0 | command pv --progress --rate --bytes --wait --buffer-size $buffer --name "wc" | wc --bytes --total=only > $FIFOS) 1>/dev/null 2>&1 &
   catPID=$!

   command cat $FIFO2 | command pv --progress --rate --bytes --wait --buffer-size $buffer --name "writing $output" --force | sudo command dd of="$output" bs=$bs status=none 
  
   #
   # Wait for all FIFO to be closed
   #
   for pid in $ucatPID $hashPID $catPID 
   do
     wait $pid
     code=$?
        
     if [ $code != 0 ];
     then
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
   #(sudo command dd if="$output" bs=$bs status=none | pv --progress --rate --bytes --wait --buffer-size $buffer --stop-at-size --size $sizeWrittenBytes --name "verification" | sha256sum) > $FIFOH 2>/dev/null &
   sudo command dd if="$output" bs=$bs status=none | pv --progress --rate --bytes --wait --buffer-size $buffer --stop-at-size --size $sizeWrittenBytes --name "verification" | sha256sum > $FIFOH
   hash2="$(command cat $FIFOH)"

   command rm -f $FIFOH

   if [ "$hash" != "$hash2" ];
   then
       echo "verification: failed."
       return 1
   else
       echo "verification: OK"
   fi
}
