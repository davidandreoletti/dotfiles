# Theme (until I switched to powerline)
set-option -g status-bg red
set-option -g status-fg white
set-option -g status-interval 60
set-option -g status-left-length 30
set-option -g status-left '#[fg=green](#S) #(whoami)@#H#[default]'
set-option -g status-right '#[fg=yellow]#(cut -d " " -f 1-3 /proc/loadavg)#[default] #[fg=blue]%H:%M#[default]'

