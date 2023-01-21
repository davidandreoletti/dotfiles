# Homebrew
# Note: Use homebrew in priority (outside the homebrew plugin because some plugins called before homebrew plugin is called need 'brew' to be in the PATH)
# case: macos
[ -d "/usr/local/bin" ] && export PATH=/usr/local/bin:$PATH
# case: linux
[ -d "/home/linuxbrew/.linuxbrew/bin" ] && export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

export PATH

# XDG directories difference between Linux and macOS.
# https://practical.li/blog/posts/adopt-FreeDesktop.org-XDG-standard-for-configuration-files/
