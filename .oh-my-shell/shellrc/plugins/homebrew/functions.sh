# Install (one or multiple) selected application(s)
# using "brew search" as source input
# mnemonic [B]rew [I]nstall [P]lugin
# src: https://github.com/junegunn/fzf/wiki/examples#homebrew
f_homebrew_bip() {
  local inst=$(brew search "$@" | fzf -m)

  if [[ $inst ]]; then
    for prog in $(echo $inst);
    do brew install $prog; done;
  fi
}
# Update (one or multiple) selected application(s)
# mnemonic [B]rew [U]pdate [P]lugin
# src: https://github.com/junegunn/fzf/wiki/examples#homebrew
f_homebrew_bup() {
  local upd=$(brew leaves | fzf -m)

  if [[ $upd ]]; then
    for prog in $(echo $upd);
    do brew upgrade $prog; done;
  fi
}
# Delete (one or multiple) selected application(s)
# mnemonic [B]rew [C]lean [P]lugin (e.g. uninstall)
# src: https://github.com/junegunn/fzf/wiki/examples#homebrew
f_homebrew_bcp() {
  local uninst=$(brew leaves | fzf -m)

  if [[ $uninst ]]; then
    for prog in $(echo $uninst);
    do; brew uninstall $prog; done;
  fi
}

# Install or open the webpage for the selected application 
# using brew cask search as input source
# and display a info quickview window for the currently marked application
#install() {
f_homebrew_bcip() {
    local token
    token=$(brew cask search | fzf-tmux --query="$1" +m --preview 'brew cask info {}')

    if [ "x$token" != "x" ]
    then
        echo "(I)nstall or open the (h)omepage of $token"
        read input
        if [ $input = "i" ] || [ $input = "I" ]; then
            brew cask install $token
        fi
        if [ $input = "h" ] || [ $input = "H" ]; then
            brew cask home $token
        fi
    fi
}

# Uninstall or open the webpage for the selected application 
# using brew list as input source (all brew cask installed applications) 
# and display a info quickview window for the currently marked application
#uninstall() {
f_homebrew_bcup () {
    local token
    token=$(brew cask list | fzf-tmux --query="$1" +m --preview 'brew cask info {}')

    if [ "x$token" != "x" ]
    then
        echo "(U)ninstall or open the (h)omepage of $token"
        read input
        if [ $input = "u" ] || [ $input = "U" ]; then
            brew cask uninstall $token
        fi
        if [ $input = "h" ] || [ $token = "h" ]; then
            brew cask home $token
        fi
    fi
}

# Workflow to edit a brew formula, run tests
f_homebrew_core_fix_package () {
    local package_name="$1"
    # src: https://github.com/Homebrew/homebrew-core/blob/master/CONTRIBUTING.md#to-contribute-a-fix-to-the-foo-formula

    # Tap homebrew core
    brew tap homebrew/core

    # Edit formula
    brew edit $package_name

    brew uninstall --force $package_name
    HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source $package_name
    brew test $package_name
    brew audit --strict $package_name
    brew style $package_name
}
