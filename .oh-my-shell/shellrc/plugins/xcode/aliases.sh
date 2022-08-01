# http://stackoverflow.com/a/18933476/219728
alias xcodePurgeDerivedData='rm -rf ~/library/Developer/Xcode/DerivedData/*'

alias xcodePurgeAllCaches='(
echo "Delete Archived Applications"
rm -rfv ~/Library/Developer/Xcode/Archives/*/
echo "Delete Devired Data"
rm -rfv ~/Library/Developer/Xcode/DerivedData/*/
echo "Delete Apple cached files"
rm -rfv ~/Library/Developer/CoreSimulator/Caches/dyld/*/*/
echo "Delegete cache on com.apple.DeveloperTools"
rm -rfv /private/var/folders/dk/*/C/com.apple.DeveloperTools/*/
echo "Delete unused simulators"
xcrun simctl delete unavailable
)'

