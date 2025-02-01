gh extension install github/gh-copilot --force

edir=~/.config/github-copilot
efile=$edir/hosts.json

if [[ ! -d "$edir" ]]; then
	mkdir "$edir"
fi

if [[ ! -f "$efile" ]]; then
	cat <<EOF >$efile
{
  "github.com": {
    "user": "$(op read 'op://private/github.com/gh-username')",
    "oauth_token": "$(op read 'op://private/github.com/copilot-token')"
  }
}
EOF
fi
