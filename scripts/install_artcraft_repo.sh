#!/usr/bin/env bash
# Enables ArtCraft's pacman repository on an omarchy host, the way
# https://getartcraft.com/linux describes for Arch: import the signing key and
# sign it locally, install the repository config, include it from
# /etc/pacman.conf, sync.
#
# The key is checked against the fingerprint pinned below before pacman is
# told to trust it, and the repository config comes from
# config/omarchy/pacman/artcraft.conf rather than a download. Idempotent: what
# is already in place is left alone, and nothing asks for root when all of it
# is. Root is a sudo prompt from a terminal and a pkexec dialog without one.
#
# `omarchy refresh pacman` rewrites /etc/pacman.conf and drops the include;
# config/omarchy/hooks/pre-refresh-pacman.d/artcraft-repo runs this again.
set -eu

dotfiles="${DOTFILES:-$HOME/.dotfiles}"
conf_src="$dotfiles/config/omarchy/pacman/artcraft.conf"
conf_dst="/etc/pacman.d/artcraft.conf"
include="Include = $conf_dst"
key_url="https://getartcraft.com/keys/artcraft.asc"
fingerprint="2B76741B414AAD6CD33E631213A005C0B9D7C3ED"

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
	echo "Usage: scripts/install_artcraft_repo.sh [--help] [--dry-run]"
	echo
	echo "Options:"
	echo "  --help, -h   Show this help message"
	echo "  --dry-run    Report what is missing, change nothing"
	echo
	echo "Trusts key $fingerprint from $key_url"
	echo "and installs $conf_src"
	exit 0
fi

# The part that needs root; the script runs itself again for it. The paths
# and the key file are handed over as arguments, since pkexec starts with a
# clean environment and root's $HOME.
if [ "${1:-}" = "--as-root" ]; then
	key_file="$2"
	conf_src="$3"
	if ! pacman-key --list-keys "$fingerprint" 2>/dev/null | grep -q '\[ *full *\]'; then
		pacman-key --add "$key_file"
		pacman-key --lsign-key "$fingerprint"
	fi
	install -Dm644 "$conf_src" "$conf_dst"
	grep -Fxq "$include" /etc/pacman.conf || printf '\n%s\n' "$include" >>/etc/pacman.conf
	# Only so the new repository has a database to install from.
	[ -f /var/lib/pacman/sync/artcraft.db ] || pacman -Sy
	exit 0
fi

dry_run=false
for arg in "$@"; do
	case "$arg" in
	--dry-run) dry_run=true ;;
	*)
		echo "unknown option: $arg" >&2
		echo "try: scripts/install_artcraft_repo.sh --help" >&2
		exit 1
		;;
	esac
done

todo=""
pacman-key --list-keys "$fingerprint" 2>/dev/null | grep -q '\[ *full *\]' || todo="$todo key"
cmp -s "$conf_src" "$conf_dst" || todo="$todo config"
grep -Fxq "$include" /etc/pacman.conf || todo="$todo include"
[ -f /var/lib/pacman/sync/artcraft.db ] || todo="$todo sync"

if [ -z "$todo" ]; then
	echo "artcraft repository already enabled"
	exit 0
fi

echo "artcraft repository, to do:$todo"
if [ "$dry_run" = true ]; then
	echo "dry run, nothing changed"
	exit 0
fi

# Fetch the key as the user and refuse it unless it is the pinned one.
key_file=$(mktemp)
trap 'rm -f "$key_file"' EXIT
curl -fsSL "$key_url" -o "$key_file"
found=$(gpg --show-keys --with-colons "$key_file" 2>/dev/null | awk -F: '$1 == "fpr" { print $10; exit }')
if [ "$found" != "$fingerprint" ]; then
	echo "key at $key_url has fingerprint ${found:-none}, expected $fingerprint; nothing changed" >&2
	exit 1
fi
chmod 644 "$key_file"

self="$dotfiles/scripts/install_artcraft_repo.sh"
if [ -t 0 ]; then
	sudo bash "$self" --as-root "$key_file" "$conf_src"
else
	pkexec bash "$self" --as-root "$key_file" "$conf_src"
fi
echo "artcraft repository enabled"
