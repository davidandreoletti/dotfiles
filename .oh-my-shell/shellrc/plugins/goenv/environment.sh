# NOTE: goenv from brew is outdated: https://github.com/syndbg/goenv/issues/238
# Installation: https://github.com/syndbg/goenv/issues/80#issuecomment-833937585
#  -> brew install goenv --HEAD || brew upgrade goenv --fetch-HEAD

# Load goenv shims
eval "$(goenv init -)"

# Let goenv manager GOROOT / GOPATH
path_append "$GOROOT"
path_append "$GOPATH"
