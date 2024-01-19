# % android, adb
# # Clear connected device/simulator logs + display new logs
# ; usage: adb_clog
alias adb_clog='adb logcat -c && adb logcat'

# % android, adb
# # Print unbofuscated stacktrace
# ; usage: android_show_plaintext_stacktrace "proguard_mapping.txt" "obfucated_stacktrace.txt"
alias android_show_plaintext_stacktrace='f_android_printUnobfuscatedStackTrace $1 $2'

# % android, adb
# # List AndroidManifest.xml file data
# ; usage: android_show_manifest some.apk
alias android_show_manifest='aapt l -a '

# % android, adb
# # Reset android logs and terminal
# ; usage: android_reset_adb_terminal
alias android_reset_adb_terminal="clear; tmux clear-history; adb logcat -c; adb logcat"

# % android, adb
# # Take screenshot of Android device screen
# # src: http://blog.shvetsov.com/2013/02/grab-android-screenshot-to-computer-via.html
# ; usage: android_take_screenshot screenshot.png
alias android_take_screenshot="adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > $1"

# % android, adb
# # Take video of Android device screen
# ; usage: android_take_video
alias android_take_video="f_android_record_video $1"
