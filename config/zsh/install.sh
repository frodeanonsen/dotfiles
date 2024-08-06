#!/usr/bin/env bash

if [[ -d $ZSH_CUSTOM ]]; then
  echo "custom installed"
  exit 0
fi

mkdir $ZSH_CUSTOM
cd $ZSH_CUSTOM
mkdir themes
cd themes
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git

cd ..
mkdir plugins
cd plugins

git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
