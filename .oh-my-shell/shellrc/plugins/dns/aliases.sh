# macosx only
alias clearDNSCache='sudo killall -HUP mDNSResponder || sudo killall mDNSResponderHelper; sudo dscacheutil -flushcache'
