if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  export PATH=$(pyenv root)/shims:$PATH
  eval "$(pyenv virtualenv-init -)"
fi

