f_dd_to_disk() {
   local input="$1"
   local output="$2"

   echo "dd: $input -> $output ..."
   #statusinterval=32768 -> status update every 32 * 32768 blocks (ie 1Gb)
   dcfldd \
       if="$input" \
       of="$output" \
       status=on \
       statusinterval=32768 \
       sizeprobe=if \
       hashconv=after \
       hash=sha256,sha512

   if [ $? != 0 ];
   then
       echo "dd failed. exit code: $?."
       return
   fi

   echo "verify: $input == $output ..."
   dcfldd \
       if="$input" \
       vf="$output" \
       status=on \
       statusinterval=32768 \
       sizeprobe=if \
       hashconv=after \
       hash=sha256,sha512

   if [ $? != 0 ];
   then
       echo "verification failed. exit code: $?."
       return
   fi
}
