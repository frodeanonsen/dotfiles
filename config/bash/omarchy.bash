# Sourced from ~/.bashrc on omarchy hosts, after omarchy's own rc chain.
# Keeps the bash-specific bits of this repo in one place; omarchy stays the
# base and this layers on top.

# Prompt: the two-line starship layout, rendered with the current omarchy
# theme's colours from config/omarchy/themed/starship.toml.tpl.
_omarchy_starship="$HOME/.local/state/omarchy/current/theme/starship.toml"
[ -f "$_omarchy_starship" ] && export STARSHIP_CONFIG="$_omarchy_starship"
unset _omarchy_starship
