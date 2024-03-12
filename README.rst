ABOUT
=====

dotfiles can:

- bootstrap a machine: |bootstrapmachine|_

  - macOS
  - Fedora
  - (future) Debian/Ubuntu

- bootstrap base conf files:

  - personal environments
  - work environments

.. |bootstrapmachine| image:: https://github.com/davidandreoletti/dotfiles/actions/workflows/test_bootstrap.yml/badge.svg
.. _bootstrapmachine: https://github.com/davidandreoletti/dotfiles/actions/workflows/test_bootstrap.yml

MOTIVATION:
===========

One central place to manage permanent/recurrent software settings:

- simple dotfiles file structure
- easy update for config files
  - everything is a symbolic link
- easy install/update for software
  - package managers do most of the work
- support for secrets
  - everything is stored elsewhere

HIGHLIGHTS:
===========

- `*vim as fast+light+consistent featured editor`:
  - fast startup:
    - nvim: ~150ms
    -  vim: ~300ms
  - vim/nvim/ideavim shared config - experimental
    - feature (when supported)
    - keymap (when supported)
- `shellrc`:
  - is a POSIX shell plugin initialisation manager
  - total initialization duration:
    - zsh:  ~4s (w/ plugins + completions)
      - measured with `shellrc_benchmark_on_zsh`
    - bash: ~5s (w/ plugins + completions)
- binaries
  - rely on GNU binaries when available
  - prefer virtual env binaries over global for programming related tools (sdk, runtime, etc)
  - rolling release - always (ie no pinned binaries)

GET STARTED:
=============

Workflow for a new machine
---------------------------

1. Bootstrap a machine
2. Bootstrap conf files (+ updates plugins)

Bootstrap macOS machine
-------------------------

1. Prerequisites:

   - Xcode + Licence Accepted

       sudo xcodebuild -license

   - bash
   - Grant Terminal Full Disk Access:
       System Preferences > Security & Privacy > Privacy tab > Full Disk Access >  + Terminal.app
       Kill Terminal

2. Select bootstrap profile matching the user's account purpose

   IMPORTANT: Your most recents mac user setup was build in this order:

   - (account) davidandreoletti: (profile) primary_dev
   - (account) administrator:    (profile) admin
   - (account) davidis:          (profile) dev_multi

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


3. Run bootstrap script with the profile

   NOTE: dotfile-private can be encrypted while bootstraping.

   Current user will be a **macOS standard user**:

       git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b machine -s normal -p "$(pwd)/../dotfiles-private"

   Current user will be a **macOS Administrator privileges user**

       git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b machine -s admin -p "$(pwd)/../dotfiles-private"

   Current user will be a  **primary developer account on the machine**

       git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b machine -s dev_single -p "$(pwd)/../dotfiles-private"

   Current user will be a  **one of the secondaries developer accounts on the machine**

       git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b machine -s dev_multi -p "$(pwd)/../dotfiles-private"


Bootstrap Fedora machine
-------------------------

1. Prerequisites:

   - bash
   - dnf

2. Select bootstrap profile matching the user's account purpose

   IMPORTANT: Your most recents fedora user setup was build in this order:

   - (account) davidandreoletti: (profile) primary_dev
   - (account) administrator:    (profile) admin
   - (account) davidis:          (profile) dev_multi


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


3. Run bootstrap script with the profile

   Current user will be a **Fedora standard user**:

       git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b machine -s normal -p "$(pwd)/../dotfiles-private"

   Current user will be a **Fedora Administrator privileges user**

       git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b machine -s admin -p "$(pwd)/../dotfiles-private"

   Current user will be a  **primary developer account on the machine**

       git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b machine -s dev_single -p "$(pwd)/../dotfiles-private"

   Current user will be a  **one of the secondaries developer accounts on the machine**

       git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash -x bootstrap.sh -b machine -s dev_multi -p "$(pwd)/../dotfiles-private"



Bootstrap configuration files
---------------------------------

1. Prerequisites:

- ```bootstrap -b machine -s ...``` with homebrew packages installed minimun

2. Select bootstrap conf script profile matching the user's account purpose

   IMPORTANT: Your most recents user setup was build in this order:

   - account davidandreoletti: profile perso
   - account davidis:          profile work

   +----------------------------------+----------------------+----------------------+--------------------+-----------------------+
   | Feature                          |     standard user    |     Administrator    |      Primary Dev   |      Nthy Developer   |
   +----------------------------------+----------------------+----------------------+--------------------+-----------------------+
   |                                  | macOS     | linux    | macOS     | linux    | macOS     | linux  | macOS     | linux     |
   +==================================+======================+======================+====================+=======================+
   | Link public conf files to $HOME  | y         | y        | y         | y        | y         | y      | y         | y         |
   +----------------------------------+----------------------+----------------------+--------------------+-----------------------+
   | Link private conf files to $HOME | y         | y        | y         | y        | y         | y      | y         | y         |
   +----------------------------------+----------------------+----------------------+--------------------+-----------------------+
   | XDG_ conformity                  | y         | y        | y         | y        | y         | y      | y         | y         |
   +----------------------------------+----------------------+----------------------+--------------------+-----------------------+
   | Auto install vim plugins         | y         | y        | y         | y        | y         | y      | y         | y         |
   +----------------------------------+----------------------+----------------------+--------------------+-----------------------+


   .. _XDG: https://practical.li/blog/posts/adopt-FreeDesktop.org-XDG-standard-for-configuration-files/

3. Run bootstratp conf script matching the selected profile

   #. (if boostrap config script has never been called) Install conf files into your HOME dir:

       git clone --recursive https://github.com/davidandreoletti/dotfiles.git && cd dotfiles && bash bootstrap.sh -b dotfiles -s perso -p "$(pwd)/../dotfiles-private"

   #. Update existing conf files (overwritten):

       cd dotfiles && git pull && git submodule update --recursive --remote && bash bootstrap.sh -b dotfiles -s perso

   #. Prevent git from displaying every file whose permission have changed (yet no file content changed)

       vim THIS_REPO.git/.git/config
         filemode = false


DOCUMENTATION
=============

Execute: bootstrap -h

SOURCE
======

Main source repository: https://github.com/davidandreoletti/dotfiles


CONTRIBUTORS:
=============

Feel free to read/copy/suggest.
No code contribution accepted.

AUTHOR
======

David Andreoletti <http://david.andreoletti.net> - Original author

THANKS
======

- Mathias Bynens - https://github.com/mathiasbynens/dotfiles - Bootstrap.sh
- Amir Salihefendic - https://github.com/amix/vimrc - Initial vimrc file structure
- Others (see source code for references)
