if command -v yq >/dev/null 2>&1; then
  export HASS_SERVER=`cat ~/.dotfiles/secret.yaml | yq '.hass.url' -r`
  export HASS_TOKEN=`cat ~/.dotfiles/secret.yaml | yq '.hass.token' -r`
fi
