# Clear connected device/simulator logs + display new logs
# Usage: adb_clog 
alias adb_clog='adb logcat -c && adb logcat'

# Print unbofuscated stacktrace
# Usage: android_show_plaintext_stacktrace "proguard_mapping.txt" "obfucated_stacktrace.txt"
alias android_show_plaintext_stacktrace='f_android_printUnobfuscatedStackTrace $1 $2'

# List AndroidManifest.xml file data
# Usage: android_show_manifest some.apk
alias android_show_manifest='aapt l -a '

# Reset android logs and terminal
alias android_reset_adb_terminal="clear; tmux clear-history; adb logcat -c; adb logcat"

# Take screenshot of Android device screen
# src: http://blog.shvetsov.com/2013/02/grab-android-screenshot-to-computer-via.html
# usage: android_take_screenshot screenshot.png
alias android_take_screenshot="adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > $1"

alias android_take_video="f_android_record_video $1"

