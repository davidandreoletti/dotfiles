# Do not share analytics data
export HOMEBREW_NO_ANALYTICS=1

# Init homebrew
if [[ "$OS_NAME" == "macosx" ]];
then
	# Homebrew cask default option
	# --appdir Location where cask apps are installed
	export HOMEBREW_CASK_OPTS="--appdir=/Applications"

	# TODO: Load native homebrew at runtime using 'uname -v' varying output per cpu: "RELEASE_X86_64" (x86) vs "RELEASE_ARM64_xxxx" (ARM)
	# - x86 arch
	eval "$(/usr/local/Homebrew/bin/brew shellenv)"
	# - ARM arch
	# eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$OS_NAME" == "linux" ]];
then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

