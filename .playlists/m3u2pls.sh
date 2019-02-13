# Converts a .m3u playlist to .pls playlist
# Usage: m3u2pls.sh "some/path/to/my/playlist/file.m3u" "some/path/to/my/playlist/file.pls"
m3uPlaylistFile="$1"
plsPlaylistFile="$2"

entriesCount=$(cat "$m3uPlaylistFile" | wc -l)

echo "[playlist]" > "$plsPlaylistFile"
echo "numberofentries=${entriesCount}" >> "$plsPlaylistFile"

i=1
while read -r entry;
do
    echo "File$i=$entry" >> "$plsPlaylistFile"
    echo "Title$i=Unspecified" >> "$plsPlaylistFile"
    echo "Length$i=-1" >> "$plsPlaylistFile"
    i=$((i+1))
done < "$m3uPlaylistFile"

echo "Version=2" >> "$plsPlaylistFile"
