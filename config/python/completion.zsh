if command -v uv 1>/dev/null 2>&1; then
  eval "$(uv generate-shell-completion zsh)"
fi

# Not available yet
# if command -v uvx 1>/dev/null 2>&1; then
#   eval "$(uvx --generate-shell-completion zsh)"
# fi
