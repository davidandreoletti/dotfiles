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

Bootstrap MacOS machine
-------------------------

1. Prerequisites:
- Xcode + Licence Accepted
    sudo xcodebuild -license
- bash
- Grant Terminal Full Disk Access: 
    System Preferences > Security & Privacy > Privacy tab > Full Disk Access >  + Terminal.app
    Kill Terminal

2. Select bootstrap script profile matching the user's account purpose

IMPORTANT: Your most recents mac user setup was build in this order: 
- account davidandreoletti: profile primary_dev
- account administrator:    profile admin
- account davidis:          profile dev_multi

+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Feature                          | macOS standard user  | macOS Administrator  | macOs Primary Dev  | macOS Nthy Developer  |
+==================================+======================+======================+====================+=======================+
| Xcode Command Line tools install | y                    | y                    | y                  | y                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Homebrew install                 | y                    | y                    | y                  | y                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Homebrew packages installation   | n                    | y                    | y                  | n                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Browser addons installation      | n                    | y                    | y                  | n                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Mac App Store apps installation  | n                    | y                    | y                  | n                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Tmux plugins                     | n                    | y                    | y                  | y                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Time Machine backup setup        | y                    | y                    | y                  | y                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| SSD perf optimization setup      | y                    | y                    | y                  | y                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Remote SSH                       | n                    | n                    | n                  | n                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Remote VNC                       | n                    | n                    | n                  | n                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Enable Guest Account             | n                    | y                    | y                  | n                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Create Administrator account     | n                    | n                    | y                  | n                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+


3. Run bootstrap script matching to the user's account purpose

Current user will be a **MacOS standard user**:

    git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b macosx -s normal -p "`pwd`/../dotfiles-private"

Current user will be a **MacOS Administrator privileges user**

    git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b macosx -s admin -p "`pwd`/../dotfiles-private"

Current user will be a  **primary developer account on the machine**

    git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b macosx -s dev_single -p "`pwd`/../dotfiles-private"

Current user will be a  **one of the secondaries developer accounts on the machine**

    git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b macosx -s dev_multi -p "`pwd`/../dotfiles-private"


Bootstrap Fedora machine
-------------------------

1. Prerequisites:
- bash

2. Select bootstrap script profile matching the user's account purpose

IMPORTANT: Your most recents fedora user setup was build in this order: 
- account davidandreoletti: profile primary_dev
- account administrator:    profile admin
- account davidis:          profile dev_multi

+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Feature                          | Fedora standard user | Fedora Administrator | Fedora Primary Dev | Fedora Nthy Developer  |
+==================================+======================+======================+====================+=======================+
| Homebrew install                 | y                    | y                    | y                  | y                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Homebrew packages installation   | n                    | y                    | y                  | n                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Browser addons installation      | n                    | y                    | y                  | n                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Tmux plugins                     | n                    | y                    | y                  | y                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Enable Guest Account             | n                    | y                    | y                  | n                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+
| Create Administrator account     | n                    | n                    | y                  | n                     |
+----------------------------------+----------------------+----------------------+--------------------+-----------------------+


3. Run bootstrap script matching to the user's account purpose

Current user will be a **Fedora standard user**:

    git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b fedora -s normal -p "`pwd`/../dotfiles-private"

Current user will be a **Fedora Administrator privileges user**

    git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b fedora -s admin -p "`pwd`/../dotfiles-private"

Current user will be a  **primary developer account on the machine**

    git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b fedora -s dev_single -p "`pwd`/../dotfiles-private"

Current user will be a  **one of the secondaries developer accounts on the machine**

    git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b fedora -s dev_multi -p "`pwd`/../dotfiles-private"



Bootstrap configuration files
---------------------------------

1. Prerequisites:
- ```bootstrap -b <macosx|fedora> -s ...``` with homebrew packages installed minimun

2. Select bootstrap conf script profile matching the user's account purpose

IMPORTANT: Your most recents mac user setup was build in this order: 
- account davidandreoletti: profile perso
- account davidis:          profile ?

3. Run bootstratp conf script matching the selected profile

a. (if boostrap config script has never been called) Install conf files into your HOME dir:

   git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash bootstrap.sh -b dotfiles -s perso -p "`pwd`/../dotfiles-private"

b. (if boostrap config script has been edited since) Update existing conf files (overwritten):

   cd dotfiles && git pull && git submodule update --recursive --remote && bash bootstrap.sh -b dotfiles -s perso

c. Prevent git from displaying every file those permission have changed (yet no file content changed)

   vim THIS_REPO.git/.git/config
      filemode = false


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
