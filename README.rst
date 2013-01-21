dotfiles

ABOUT
=====

dotfiles contains numerous configuration files.

MOTIVATION:
===========

Configuration files used to customize my workflow.

INSTALLATION:
=============

The bootstrapper script will pull in the latest version and copy the files to your home folder.

git clone https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && source bootstrap.sh
To update, cd into your local dotfiles repository and then:

source bootstrap.sh
Alternatively, to update while avoiding the confirmation prompt:

set -- -f; source bootstrap.sh
Git-free install

To install these dotfiles without Git:

cd; curl -#L https://github.com/davidandreoletti/dotfiles.git/tarball/master | tar -xzv --strip-components 1 --exclude={README.rst,bootstrap.sh}
To update later on, just run that command again.

DOCUMENTATION
=============

Files are fully documented.e

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
