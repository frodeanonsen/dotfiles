edir=~/.config/exercism

if [[ ! -d "$edir" ]]; then
  mkdir "$edir"
fi

if [[ ! -f "$edir/user.json" ]]; then
  cat <<EOF > $edir/user.json
{
  "apibaseurl": "https://api.exercism.io/v1",
  "token": "$(op read 'op://private/Exercism/API token')"
  "workspace": "$HOME/Exercism"
}
EOF
fi
