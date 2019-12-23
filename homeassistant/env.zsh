if command -v yq >/dev/null 2>&1; then
  export HASS_SERVER=`yq r ~/.dotfiles/secret.yaml hass.url`
  export HASS_TOKEN=`yq r ~/.dotfiles/secret.yaml hass.token`
fi
