# Usage: create_macos_installer_disk.sh "Ventura" "/Volumes/MyVolume"
# src: https://support.apple.com/en-us/101578
macOSVersionName="${1:-Ventura}"
volumeToCreateImgOnto="${2:-/Volumes/Missing}"

sudo /Applications/Install\ macOS\ ${macOSVersionName}.app/Contents/Resources/createinstallmedia --volume "$volumeToCreateImgOnto"

