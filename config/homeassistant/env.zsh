if command -v yq >/dev/null 2>&1; then
  export HASS_SERVER=`cat ~/.dotfiles/secret.yaml | yq '.hass.url' -`
  export HASS_TOKEN=`cat ~/.dotfiles/secret.yaml | yq '.hass.token' -`
fi
