# use  cmd --help |bathelp
alias bat=batcat
alias bathelp='batcat --plain --language=help'
help() {
    "$@" --help 2>&1 | bathelp
}

# Use bat for man pages
export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
# man 2 select
