i=25
for url in http://datashat.net/music_for_programming_11-miles_tilmann.mp3 http://datashat.net/music_for_programming_12-forgotten_light.mp3 http://datashat.net/music_for_programming_13-matt_whitehead.mp3 http://datashat.net/music_for_programming_14-tahlhoff_garten_and_untitled.mp3 http://datashat.net/music_for_programming_15-dan_adeyemi.mp3 http://datashat.net/music_for_programming_16-silent_stelios.mp3 http://datashat.net/music_for_programming_17-graphplan.mp3 http://datashat.net/music_for_programming_18-konx_om_pax.mp3 http://datashat.net/music_for_programming_19-hivemind.mp3 http://datashat.net/music_for_programming_20-uberdog.mp3 http://datashat.net/music_for_programming_21-idol_eyes.mp3 http://datashat.net/music_for_programming_22-mindaugaszq.mp3 http://datashat.net/music_for_programming_23-panda_magic.mp3 http://datashat.net/music_for_programming_24-rites.mp3 http://datashat.net/music_for_programming_25-_nono_.mp3 http://datashat.net/music_for_programming_26-abstraction.mp3 http://datashat.net/music_for_programming_27-michael_hicks.mp3 http://datashat.net/music_for_programming_28-big_war.mp3 http://datashat.net/music_for_programming_29-luke_handsfree.mp3
do
    echo "File${i}=$url"
    echo "Title${i}=$url"
    echo "Length${i}=-1"
    i=$((i+1))
done


