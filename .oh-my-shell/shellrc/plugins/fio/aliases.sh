_FIO_PROFILE_DIR="$HOME/.oh-my-shell/shellrc/plugins/fio"
# Run various IO requests to test real hardware disk IOPS
# Usage: fio_test_real_iops_on_directory /path/to/mounted/dir
alias fio_test_real_iops_on_directory='f_fio_run_mounted_disk_perf ${_FIO_PROFILE_DIR}/iops.fio 1 '
# Run various IO requests to test real hardware disk thoughput
# Usage: fio_test_real_iops_on_directory /path/to/mounted/dir
alias fio_test_real_thoughput_on_directory='f_fio_run_mounted_disk_perf ${_FIO_PROFILE_DIR}/throughput.fio 1 '
# Run various IO requests to test real hardware disk latency
# Usage: fio_test_real_iops_on_directory /path/to/mounted/dir
alias fio_test_real_latency_on_directory='f_fio_run_mounted_disk_perf ${_FIO_PROFILE_DIR}/latency.fio 1 '
# Run various IO requests to strees test hardware disk
# Usage: fio_test_real_stress_on_directory /path/to/mounted/dir
alias fio_test_real_stress_on_directory='f_fio_run_mounted_disk_perf ${_FIO_PROFILE_DIR}/stress.fio 1 '
