{
    # Jan 2024: Install zsh-bench until it becomes available on homebrew
    mkdir -p "$(dirname ${_ZSH_BENCH_DIR})"
    git -C "${_ZSH_BENCH_DIR}" pull || git clone "https://github.com/romkatv/zsh-bench.git" "${_ZSH_BENCH_DIR}"
} 1>/dev/null 2>&1 # silent
