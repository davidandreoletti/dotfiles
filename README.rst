ABOUT
=====

dotfiles contains:

- configuration files for both personal and work machines
- script to bootstrap a MacOS machine.
- script to bootstrap a Debian based machine.

MOTIVATION:
===========

I have custom settings for various software I used everyday.

GET STARTED:
=============

Bootstrap configuration files
---------------------------------

First conf files installation (into your HOME dir):

    git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && source bootstrap.sh -b dotfiles -s perso -p "`pwd`/../dotfiles-private"

To update existing conf files (overwritten):

   cd dotfiles && git pull && git submodule update --recursive --remote && source bootstrap.sh -b dotfiles -s perso

Bootstrap MacOS machine
-------------------------

Current user as **MacOS standard user**

    git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && source bootstrap.sh -b macosx -s normal -p "`pwd`/../dotfiles-private"


Current user as **MacOS Administrator privileges user**

    git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && source bootstrap.sh -b macosx -s admin -p "`pwd`/../dotfiles-private"

Current user as **single developer account on the machine**

    git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && source bootstrap.sh -b macosx -s dev_single -p "`pwd`/../dotfiles-private"

Current user as **one of the many developer accounts on the machine**

    git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && source bootstrap.sh -b macosx -s dev_multi -p "`pwd`/../dotfiles-private"

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
