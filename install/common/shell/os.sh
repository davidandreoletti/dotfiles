# Keep is_xxx in sync with .oh-my-shell/shellrc/bootstrap/helper2.sh

is_macos () {
    case "$(uname -sr)" in
        Darwin*)
        return 0
        ;;
        *)
        return 1
        ;;
    esac
}

is_linux () {
    case "$(uname -sr)" in
        Linux*)
        return 0
        ;;
        *)
        return 1
        ;;
    esac
}

is_fedora () {
    case "$(grep -E '^(ID)=' /etc/os-release | cut -d'=' -f 2)" in
        fedora*)
        return 0
        ;;
        *)
        return 1
        ;;
    esac
}

is_archlinux () {
    case "$(grep -E '^(ID)=' /etc/os-release | cut -d'=' -f 2)" in
        arch*)
        return 0
        ;;
        *)
        return 1
        ;;
    esac
}
