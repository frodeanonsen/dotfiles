if command -v yq >/dev/null 2>&1; then
  export HASS_SERVER=`cat ~/.dotfiles/secret.yaml | yq e '.hass.url' -`
  export HASS_TOKEN=`cat ~/.dotfiles/secret.yaml | yq e '.hass.token' -`
fi
