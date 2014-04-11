ABOUT
=====

dotfiles contains numerous configuration files.

MOTIVATION:
===========

I have custom settings for various softwares I used everyday. 

INSTALLATION:
=============

Git based installation
----------------------

This one liner clones this repository and install the files in your HOME dir.

    git clone https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && source bootstrap.sh

To update, cd into your local dotfiles repository and then:

    git pull && source bootstrap.sh

Alternatively, to update without confirmation prompt:

    git pull; set -- -f; source bootstrap.sh

Git free installation
---------------------

This one liner get a copy of the master branch and install the files in your HOME dir.

    cd; curl -#L https://github.com/davidandreoletti/dotfiles.git/tarball/master | tar -xzv --strip-components 1 --exclude={README.rst,bootstrap.sh}

To update later on, just run that command again.

DOCUMENTATION
=============

Files are fully documented.

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
