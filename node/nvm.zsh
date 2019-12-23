if [[ -d ~/.nvm ]]; then
  export NVM_DIR="$HOME/.nvm"
  if [[ -f "$NVM_DIR/nvm.sh" ]]; then
    . "$NVM_DIR/nvm.sh"
  fi
fi
