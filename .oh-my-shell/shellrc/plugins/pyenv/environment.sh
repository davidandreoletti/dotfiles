# Python version manager on macOS
# - https://opensource.com/article/19/5/python-3-default-mac
export PYENV_ROOT="$HOME/.pyenv"

# src: https://github.com/pyenv/pyenv-virtualenv/issues/135
# Not sure I want this yet
#export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Init pyenv:
# - Define where pyenv repo is cloned 
# - Path to pyenv binary
# - Enable pyenv shim 
# - Install the sh dispatch
eval "$(pyenv init -)"

# Init pyenv plugins
if command -v pyenv-virtualenv-init > /dev/null; 
then 
    eval "$(pyenv virtualenv-init -)"; 
fi

