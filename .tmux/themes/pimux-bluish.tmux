# Src: https://github.com/ndyakov/pimux
# Colors
BACKGROUND=black
FOREGROUND=white
HIGHLIGHT="#3fcfff"
ACTIVITY="#a0d0f0"

# Title
set -g set-titles on
set -g set-titles-string '#(whoami)@#H - (#S:#W.#P)'

# Panes
set -g pane-border-style fg=default
set -g pane-active-border-style bg=default,fg=$HIGHLIGHT

set -g display-panes-time 1000
set -g display-panes-colour $FOREGROUND
set -g display-panes-active-colour $HIGHLIGHT

# Clock
set -g clock-mode-colour $FOREGROUND
set -g clock-mode-style 24

# Mode
set -g mode-style bg=$HIGHLIGHT,fg=$BACKGROUND

# Windows

setw -g window-status-format " #I:#W"
setw -g window-status-style bg=default,fg=$FOREGROUND,dim

setw -g window-status-last-style fg=$FOREGROUND,bold

setw -g window-status-current-format " #I:#W"
setw -g window-status-current-style bg=default,fg=$HIGHLIGHT,bold

setw -g window-status-activity-style bg=$BACKGROUND,fg=$ACTIVITY,dim

## Cannot use:
##  - screen-bce, screen-256color-bce: tmux does not support bce
##  - screen-256color: vim broken without -bce
set -g default-terminal "screen-256color"

# Base index ( start counting from 1 )
set -g base-index 1
setw -g pane-base-index 1

# Status Top
set -g status-position top

# Status Colors
set -g status-bg $BACKGROUND
set -g status-fg $FOREGROUND

# Status Interval
# But there is a strange bug that freezes osx
# https://github.com/tmux/tmux/issues/108
# set to 0
set -g status-interval 0

# Status contents
set -g status-left ' π '
set -g status-right '| #S:#I.#P '

# Message
set -g message-style bg=$BACKGROUND,fg=$HIGHLIGHT,bright

# vim: set syntax=tmux:
