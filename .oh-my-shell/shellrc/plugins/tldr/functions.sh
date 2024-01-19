function f_tldr_aggregate() {
    local program="$1"
    if command_exists cheat; then
        cat <(echo "--tldr: $program ---------------------------------------") \
            <(command tldr $program) \
            <(echo "--cheat: $program ---------------------------------------") \
            <(command cheat $program)
    else
        echo "None"
    fi
}
