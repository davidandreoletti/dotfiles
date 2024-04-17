is_arch_x86_64() {
    architecture=""
    case $(uname -m) in
        x86_64) return 0 ;;
        *) return 1 ;;
    esac
}
