# Remove if slow start
if [[ -d ~/.nvm ]]; then
   export NVM_DIR="$HOME/.nvm"
   if [[ -f "$NVM_DIR/nvm.sh" ]]; then
     . "$NVM_DIR/nvm.sh"
     . "$NVM_DIR/bash_completion"
     nvm use default
   fi
 fi
