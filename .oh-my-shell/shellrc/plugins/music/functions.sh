function f_music_flac_to_alac() {
    # get the input / output directories
    FLAC_DIR="$1"
    ALAC_DIR="$2"

    mkdir -p "$ALAC_DIR"

    pushd "$FLAC_DIR"
    set -x

    while read -r f; do
        f2="$(basename $f)"
        d2="$(dirname $f)"

        f3="${f2%.flac}.m4a"
        f3="$(basename $f3)"
        d3="$ALAC_DIR/$d2"

        mkdir -p "$d3"

        docker run --rm --name flac_to_alac -v "$d2:/data/in" -v "$d3:/data/out" linuxserver/ffmpeg:version-7.0-cli -i "/data/in/$f2" -c:v copy -c:a alac "/data/out/$f3"
    done <<<"$(find . -type f -name '*.flac')"

    set +x
    popd
}
