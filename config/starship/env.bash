# Prompt: the two-line starship layout, rendered with the current omarchy
# theme's colours from config/omarchy/themed/starship.toml.tpl. Omarchy's own
# rc already ran `starship init bash`; STARSHIP_CONFIG is read at prompt time.
_omarchy_starship="$HOME/.local/state/omarchy/current/theme/starship.toml"
[ -f "$_omarchy_starship" ] && export STARSHIP_CONFIG="$_omarchy_starship"
unset _omarchy_starship
