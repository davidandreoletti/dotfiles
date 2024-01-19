# Usage: f_android_printUnobfuscatedStackTrace "proguard_mapping.txt" "obfucated_stacktrace.txt"
f_android_printUnobfuscatedStackTrace() {
    '$ANDROID_HOME/tools/proguard/bin/retrace.sh -verbose "$1" "$2"'
}

# Take video of Android device screen
# usage: androidTakeVideo video.mp4
function f_android_record_video() {
    echo "Ctrl+C to stop recording."
    adb shell rm /sdcard/$1
    adb shell -x screenrecord --bit-rate 10000000 /sdcard/$1
    echo "Saving file to $(pwd)/$1."
    sleep 2s # Wait for file to be saved fully on device
    adb pull /sdcard/$1
}
