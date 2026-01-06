# Simplify tmux version (eg: not 3.5a but 3.5)
_tmux_version="$(tmux -V | command awk '{print $2}')"
export TMUX_VERSION="$(command awk -v version="${_tmux_version}" "BEGIN { print substr(version,1,3) }")"
