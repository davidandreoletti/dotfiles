#!/bin/bash

echo "TRUE COLORS displayed in RED ?"
printf "\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"

echo "y/n ?"
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then 
    PROGRAM="$TERM_PROGRAM ( $TERM )"
    echo "True color/24bit supported on $PROGRAM"
else
    echo "Smooth color gradient displayed displayed ??"
    awk -v term_cols="${width:-$(tput cols || echo 80)}" -v term_lines="${height:-1}" 'BEGIN{
        s="/\\";
        total_cols=term_cols*term_lines;
        for (colnum = 0; colnum<total_cols; colnum++) {
            r = 255-(colnum*255/total_cols);
            g = (colnum*510/total_cols);
            b = (colnum*255/total_cols);
            if (g>255) g = 510-g;
            printf "\033[48;2;%d;%d;%dm", r,g,b;
            printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
            printf "%s\033[0m", substr(s,colnum%2+1,1);
            if (colnum%term_cols==term_cols) printf "\n";
        }
        printf "\n";
    }'

    echo "y/n ?"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then 
        echo "True color/24bit supported"
    else
        echo "True color/24bit NOT supported"
    fi
fi
