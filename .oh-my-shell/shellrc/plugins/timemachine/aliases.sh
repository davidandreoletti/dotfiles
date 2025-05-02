# src: https://developer.apple.com/forums/thread/49491
alias timemachine_show_logs="log show --predicate 'subsystem == "com.apple.TimeMachine"' --info | grep 'upd: (' | cut -c 1-19,140-999"

# Usage: timemachine_purge_all_localsnapshots
alias timemachine_purge_all_localsnapshots='for d in $(tmutil listlocalsnapshotdates | grep "-"); do sudo tmutil deletelocalsnapshots $d; done'
