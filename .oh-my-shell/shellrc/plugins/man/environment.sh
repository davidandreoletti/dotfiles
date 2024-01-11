# -X: Don’t clear the screen after quitting a manual page
# src: https://felipec.wordpress.com/2021/06/05/adventures-with-man-color/
export MANPAGER="less -R --use-color -Dd+r -Du+b -X"
#export MANPAGER='nvim +Man!'
export MANROFFOPT="-c"
