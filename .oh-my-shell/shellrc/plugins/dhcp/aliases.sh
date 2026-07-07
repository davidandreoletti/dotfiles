# Display DHCP options returned by the DHCP server for a given interface
# Usage: dhcp_discover_dhcp_options eth1
# Note: requires to enter password and the command is slow to return responses (~10s)
alias dhcp_discover_dhcp_options='sudo nmap --script broadcast-dhcp-discover -e '
