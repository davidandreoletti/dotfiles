#
# HTTP Traffic
#

# Show HTTP traffic on (default) all interfaces to/from port (default) 80 whose HTTP verbs are (default) GET|POST|PUT}PATCH|DELETE
# (ues ngrep)
# Usage: http_show_traffic any 80 "GET|POST"
alias http_show_traffic="f_http_show_in_out_traffic "

# Show HTTP traffic on (default) all interfaces to/from port (default) 80 whose HTTP verbs are (default) GET|POST|PUT}PATCH|DELETE
# (ues tcpdump)
# Usage: http_show_traffic2 any 80 "GET|POST"
alias http_show_traffic2="f_http_show_in_out_traffic2 "
