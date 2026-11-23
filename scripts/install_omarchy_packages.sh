#!/usr/bin/env bash
# Installs the packages listed in config/omarchy/packages on an omarchy host.
#
# Wraps `omarchy pkg add`, which is a --needed pacman install, so this is
# idempotent and safe to re-run after pulling. pacman needs root: from a
# terminal that is a sudo password prompt, without one it is a pkexec dialog.
# It first enables ArtCraft's pacman repository with install_artcraft_repo.sh.
# Names listed as aur/<name> go through `omarchy pkg aur add` (yay) instead.
# yay builds as the user and calls sudo itself, so those need a terminal and
# are reported and left alone without one.
# A name with no build for this machine's architecture (vivaldi and some AUR
# -bin packages are x86_64 only, which matters on the aarch64 Asahi zygbook)
# is reported and skipped, so one of them does not fail the whole batch.
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

# The list names packages from ArtCraft's repository, which has to be enabled
# before pacman can find them.
if [ "$dry_run" = true ]; then
	"$dotfiles/scripts/install_artcraft_repo.sh" --dry-run
else
	"$dotfiles/scripts/install_artcraft_repo.sh"
fi

# Strip comments and blank lines, keep the first word of each line.
packages=$(sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]].*//' "$list" | grep -v '^$')

arch="$(uname -m)"

# Whether an AUR package builds for this machine, from the arch lines of its
# .SRCINFO. When the AUR cannot be reached it says yes and leaves it to yay.
aur_has_arch() {
	local srcinfo
	srcinfo=$(curl -fsS --max-time 10 "https://aur.archlinux.org/cgit/aur.git/plain/.SRCINFO?h=$1" 2>/dev/null) || return 0
	printf '%s\n' "$srcinfo" | grep -qE "^[[:space:]]*arch = ($arch|any)\$"
}

missing=""
missing_aur=""
unavailable=""
for pkg in $packages; do
	name="${pkg#aur/}"
	if pacman -Q "$name" >/dev/null 2>&1; then
		continue
	fi
	if [ "$name" = "$pkg" ]; then
		if pacman -Si "$name" >/dev/null 2>&1; then
			missing="$missing $name"
		else
			unavailable="$unavailable $name"
		fi
	elif aur_has_arch "$name"; then
		missing_aur="$missing_aur $name"
	else
		unavailable="$unavailable aur/$name"
	fi
done

if [ -n "$unavailable" ]; then
	echo "not available for $arch, skipped:$unavailable"
	# A dry run has not enabled the ArtCraft repository yet, so its packages
	# land here until the first real run.
	[ "$dry_run" = false ] || echo "(a repository the real run enables first is not searched in a dry run)"
fi

if [ -z "$missing" ] && [ -z "$missing_aur" ]; then
	echo "all packages present, nothing to do"
	exit 0
fi

[ -z "$missing" ] || echo "missing:$missing"
[ -z "$missing_aur" ] || echo "missing from the AUR:$missing_aur"
if [ "$dry_run" = true ]; then
	echo "dry run, nothing installed"
	exit 0
fi

# omarchy-pkg-add uses sudo, which needs a terminal for the password. Without
# one (e.g. run from an agent or the `!` runner in Claude Code) fall back to
# pkexec, which asks through a graphical dialog instead.
if [ -z "$missing" ]; then
	:
elif [ -t 0 ]; then
	# shellcheck disable=SC2086
	omarchy-pkg-add $missing
else
	# shellcheck disable=SC2086
	pkexec pacman -S --noconfirm --needed $missing
fi

if [ -z "$missing_aur" ]; then
	:
elif [ -t 0 ]; then
	# shellcheck disable=SC2086
	omarchy-pkg-aur-add $missing_aur
else
	echo "no terminal for yay's sudo prompt, AUR packages not installed:$missing_aur" >&2
	echo "run scripts/install_omarchy_packages.sh from a terminal" >&2
	exit 1
fi
