# Suite of completions from "zsh-completion" homebrew package 
# - must be set before "compinit"
FPATH=$(homebrew_package_path_prefix "/zsh-completions/share/zsh-completions"):$FPATH

# compinit is now loaded by zsh-autocomplete.plugin.zsh
## Initialize completion system
## -U 
#autoload -Uz compinit
## -u use completion scripts files not owned by the current user or root.
##    Rationale: Homebrew install completions scripts with owner sometimes set as different from the current user 
#compinit -u
#
#zstyle ':completion:*' auto-description 'specify: %d'
#zstyle ':completion:*' completer _expand _complete _correct _approximate
#zstyle ':completion:*' format 'Completing %d'
#zstyle ':completion:*' group-name ''
#zstyle ':completion:*' menu select=2 eval "$(dircolors -b)"
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:*' list-colors ''
#zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
#zstyle ':completion:*' menu select=long
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#zstyle ':completion:*' use-compctl false
#zstyle ':completion:*' verbose true

# Completion for installed homebrew packages, without completion profile.d support  
HOMEBREW_FZF_COMPLETION_DIR=$(homebrew_package_path_prefix "/fzf/shell/completion.zsh")
dot_if_exists "$HOMEBREW_FZF_COMPLETION_DIR"

# Enables:
# - CTRL-T as fzf file chooser.
# -- Eg: vim <ctrl-t>
# - CTRL-R as fzf history chooser.
HOMEBREW_FZF_KEYBINDINGS_DIR=$(homebrew_package_path_prefix "/fzf/shell/key-bindings.zsh")
dot_if_exists "$HOMEBREW_FZF_KEYBINDINGS_DIR"

# Real time completion
dot_if_exists "$(homebrew_package_path_prefix "/zsh-autocomplete/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh")"

# Suggestions
dot_if_exists "$(homebrew_package_path_prefix "/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh")"
