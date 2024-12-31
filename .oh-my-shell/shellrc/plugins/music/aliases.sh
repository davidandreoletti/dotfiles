# % music, flac, alac, transcode
# # Convert flac to alac
# ; usage: music_flac_to_alac "/src/dir" "/dest/dir"
# ; example: music_flac_to_alac "$HOME/src/flac" "/tmp/alac"
alias music_flac_to_alac='f_music_flac_to_alac '

# % music, download, youtube
# # Download music from youtube
# ; usage: music_download_from_youtube "http://some.music/or/playlist"
alias music_download_from_youtube='f_music_download_from_youtube auto '

# % music, play, local
# # Play music from local playlists
# ; usage: music_play_local 
alias music_play_local='$HOME/.bin/music'

# % music, update, local
# # Update music local playlists
# ; usage: music_update_local 
alias music_play_local='$HOME/.bin/music --update'
