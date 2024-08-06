#!/usr/bin/env bash

if [[ -d ~/.jenv ]]; then
  echo "jenv installed"
  exit 0
fi

git clone https://github.com/jenv/jenv.git ~/.jenv
