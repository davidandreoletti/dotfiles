mkdir -p $HOME/.mail/AAA
mbsync --config $HOME/.config/isync/isyncrc \
       --verbose \
       --list --list-stores
