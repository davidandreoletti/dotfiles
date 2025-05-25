f_fio_run_mounted_disk_perf() {
    local fio_file="${1}"
    # 0: false (use cache => no disk io potentially => will roughthly match dd's speed perf numbers)
    # 1: true (use no cache => always disk io =. lower than dd's speed perf)
    local invalidate_cache="$2"
    local dir="$3/.fiotest"

    local data_dir="$dir/data"
    local aux_dir="$dir/aux"
    mkdir -p "$data_dir"
    mkdir -p "$aux_dir"

    local data_checksum="$(echo -n "$data_dir" | sha256sum)"

    local test_name="$(basename "$fio_file")"

    local io_engine="null"
    if is_macos; then
        io_engine="posixaio"
    elif is_linux; then
        # Prefer io_uring
        if grep io_uring_setup /proc/kallsyms; then
            io_engine="io_uring"
        else
            io_engine="libaio"
        fi
    fi
    echo "Using io_engine: $io_engine"

    FIO_TARGET_NAME="$data_checksum" \
        FIO_IOENGINE="$io_engine" \
        FIO_INVALIDATE_CACHE_LAYER="$invalidate_cache" \
        FIO_TEST_FILE_NAME="$test_name" \
        fio --filename="$data_dir/testfile" \
        --output "${data_checksum}.output" \
        --output-format "normal,json" \
        --aux-path "$aux_dir" \
        "$fio_file"

    # FIXME eta_?
}
