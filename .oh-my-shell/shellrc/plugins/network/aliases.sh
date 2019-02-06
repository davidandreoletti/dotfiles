#
# HTTP Traffic
#

# Show HTTP traffic on (default) all interfaces to/from port (default) 80 whose HTTP verbs are (default) GET|POST|PUT}PATCH|DELETE
# (ues ngrep)
# Usage: httpShowTraffic any 80 "GET|POST"
alias httpShowTraffic="f_http_show_in_out_traffic "

# Show HTTP traffic on (default) all interfaces to/from port (default) 80 whose HTTP verbs are (default) GET|POST|PUT}PATCH|DELETE
# (ues tcpdump)
# Usage: httpShowTraffic2 any 80 "GET|POST"
alias httpShowTraffic2="f_http_show_in_out_traffic2 "

