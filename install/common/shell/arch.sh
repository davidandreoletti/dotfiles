is_arch_x86_64() {
    architecture=""
    case $(uname -m) in
        x86_64) return 0 ;;
        *) return 1 ;;
    esac
}

is_arch_aarch64() {
    architecture=""
    case $(uname -m) in
        aarch64) return 0 ;;
        *) return 1 ;;
    esac
}
