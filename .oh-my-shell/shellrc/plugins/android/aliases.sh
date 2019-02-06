# Clear connected device/simulator logs + display new logs
# Usage: adbclog 
alias adbclog='adb logcat -c && adb logcat'

# Print unbofuscated stacktrace
# Usage: androidShowPlaintextStacktrace "proguard_mapping.txt" "obfucated_stacktrace.txt"
alias androidShowPlaintextStacktrace='f_android_printUnobfuscatedStackTrace $1 $2'

# List AndroidManifest.xml file data
# Usage: showAndroidManifest some.apk
alias showAndroidManifest='aapt l -a '

# Reset android logs and terminal
alias resetAndroidDebuTerminal="clear; tmux clear-history; adb logcat -c; adb logcat"

# Take screenshot of Android device screen
# src: http://blog.shvetsov.com/2013/02/grab-android-screenshot-to-computer-via.html
# usage: androidTakeScreenshot screenshot.png
alias androidTakeScreenshot="adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > $1"

alias androidTakeVideo="f_android_record_video $1"

