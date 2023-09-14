# Display disk status after selecting a disk from TUI
# Usage: smartctl_disk_status 
alias smartctl_disk_status="diskutil list | grep '/dev' | fzf | cut -d' ' -f 1 | xargs -I% smartctl -a %"
