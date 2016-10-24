ABOUT
=====

dotfiles contains:

- custom configuration files.
- custom script to setup a Mac OS X machine.

MOTIVATION:
===========

I have custom settings for various softwares I used everyday. 

INSTALLATION:
=============

Git based installation
----------------------

This one liner clones this repository and install configuration files in your HOME dir.

    git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && source bootstrap.sh -b dotfiles -s perso 

To update, cd into your local dotfiles repository and then:

    git pull && git submodule update --recursive --remote && source bootstrap.sh -b dotfiles -s perso

Alternatively, to update without confirmation prompt:

    git pull && git submodule update --recursive --remote; set -- -f; source bootstrap.sh -b dotfiles -s perso

DOCUMENTATION
=============

Execute: bootstrap -h

SOURCE
======

Main source repository: https://github.com/davidandreoletti/dotfiles


REQUIREMENTS
============

None

CONTRIBUTORS:
=============

If you would like to contribute, feel free to do so.

AUTHOR
======

David Andreoletti <http://davidandreoletti.com> - Original author

THANKS
======

Mathias Bynens - https://github.com/mathiasbynens/dotfiles - Bootstrap.sh
Amir Salihefendic - https://github.com/amix/vimrc - Initial vimrc file structure
