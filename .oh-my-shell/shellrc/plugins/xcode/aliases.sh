# http://stackoverflow.com/a/18933476/219728
alias xcode_purge_derived_data='command rm -rf ~/library/Developer/Xcode/DerivedData/*'

alias xcode_purge_all_caches='(
echo "Delete Archived Applications"
command rm -rfv ~/Library/Developer/Xcode/Archives/*/
echo "Delete Devired Data"
command rm -rfv ~/Library/Developer/Xcode/DerivedData/*/
echo "Delete Apple cached files"
command rm -rfv ~/Library/Developer/CoreSimulator/Caches/dyld/*/*/
echo "Delete cache on com.apple.DeveloperTools"
command rm -rfv /private/var/folders/dk/*/C/com.apple.DeveloperTools/*/
echo "Delete unused simulators"
xcrun simctl delete unavailable
)'

