#!/usr/bin/env bash
# Installs the packages listed in config/omarchy/packages on an omarchy host.
#
# Wraps `omarchy pkg add`, which is a --needed pacman install, so this is
# idempotent and safe to re-run after pulling. pacman needs root: from a
# terminal that is a sudo password prompt, without one it is a pkexec dialog.
set -eu

dotfiles="${DOTFILES:-$HOME/.dotfiles}"
list="$dotfiles/config/omarchy/packages"

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
	echo "Usage: scripts/install_omarchy_packages.sh [--help] [--dry-run]"
	echo
	echo "Options:"
	echo "  --help, -h   Show this help message"
	echo "  --dry-run    List the packages that would be installed, install nothing"
	echo
	echo "Reads $list"
	exit 0
fi

dry_run=false
for arg in "$@"; do
	case "$arg" in
	--dry-run) dry_run=true ;;
	*)
		echo "unknown option: $arg" >&2
		echo "try: scripts/install_omarchy_packages.sh --help" >&2
		exit 1
		;;
	esac
done

if ! command -v omarchy-pkg-add >/dev/null 2>&1; then
	echo "omarchy-pkg-add not found; this script is for omarchy hosts" >&2
	exit 1
fi

# Strip comments and blank lines, keep the first word of each line.
packages=$(sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]].*//' "$list" | grep -v '^$')

missing=""
for pkg in $packages; do
	if ! pacman -Q "$pkg" >/dev/null 2>&1; then
		missing="$missing $pkg"
	fi
done

if [ -z "$missing" ]; then
	echo "all packages present, nothing to do"
	exit 0
fi

echo "missing:$missing"
if [ "$dry_run" = true ]; then
	echo "dry run, nothing installed"
	exit 0
fi

# omarchy-pkg-add uses sudo, which needs a terminal for the password. Without
# one (e.g. run from an agent or the `!` runner in Claude Code) fall back to
# pkexec, which asks through a graphical dialog instead.
if [ -t 0 ]; then
	# shellcheck disable=SC2086
	omarchy-pkg-add $missing
else
	# shellcheck disable=SC2086
	pkexec pacman -S --noconfirm --needed $missing
fi
