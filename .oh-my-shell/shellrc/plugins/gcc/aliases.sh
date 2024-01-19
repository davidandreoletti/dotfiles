# Show GCC's optimization turned on for native cpu
alias gcc_native_tune="gcc -march=native -Q --help=target | grep -v 'disabled'"
