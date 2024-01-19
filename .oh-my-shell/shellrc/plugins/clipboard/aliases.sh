# pbcopy/pbpaste: Take standard input and place it in the system clipboard
# (to paste into other applications)
# src: http://jetpackweb.com/blog/2009/09/23/pbcopy-in-ubuntu-command-line-clipboard/
if [ is_linux ]; then
    if command_exists 'xclip'; then
        alias pbcopy='xclip -selection clipboard'
        alias pbpaste='xclip -selection clipboard -o'
    elif command_exists 'xsel'; then
        alias pbcopy='xsel --clipboard --input'
        alias pbpaste='xsel --clipboard --output'
    fi
    unset xclippresent
    unset xselpresent
fi
