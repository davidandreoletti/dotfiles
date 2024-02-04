# Do not share analytics data
export HOMEBREW_NO_ANALYTICS=1

if is_macos; then
    # Homebrew cask default option
    # --appdir Location where cask apps are installed
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"
elif is_linux; then
    :
fi
