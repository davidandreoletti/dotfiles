function f_history_list_most_used() {
    cut -f1 -d" " $1 | sort | uniq -c | sort -nr | head -n 30
}
