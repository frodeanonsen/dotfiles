#!/bin/sh
#
# Spacemacs

# Check for existing .emacs.d / Spacemacs
if ! [ -d ~/.emacs.d ]; then
    echo "No Spacemacs. Grabbing from Github"
    git clone git@github.com:syl20bnr/spacemacs.git ~/.emacs.d
    cd ~/.emacs.d && git checkout develop
else
    echo "Spacemacs found"
fi
