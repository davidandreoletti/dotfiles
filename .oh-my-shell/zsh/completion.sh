# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2 eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Suite of completions from "zsh-completion" homebrew package 
fpath=(/usr/local/share/zsh-completions $fpath)

# Completion for installed homebrew packages, with completion profile.d support  
HOMEBREW_PROFILED_COMPLETION_DIR=$(homebrew_package_path_prefix "/etc/profile.d/zsh_completion.sh")
[ -r "$HOMEBREW_PROFILED_COMPLETION_DIR" ] && . "$HOMEBREW_PROFILED_COMPLETION_DIR"

# Completion for installed homebrew packages, without completion profile.d support  
HOMEBREW_FZF_COMPLETION_DIR=$(homebrew_package_path_prefix "/fzf/shell/completion.zsh")
[ -r "$HOMEBREW_FZF_COMPLETION_DIR" ] && . "$HOMEBREW_FZF_COMPLETION_DIR"
