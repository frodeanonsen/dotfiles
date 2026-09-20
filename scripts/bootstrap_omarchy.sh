#!/usr/bin/env bash
# Sets up an omarchy host from this repo, start to finish. Run it once after
# cloning to ~/.dotfiles, and again after pulling; every step is idempotent.
#
# What differs between machines is in config/omarchy/hosts/<hostname>/:
# home_links (extra links, read by link_config.sh), units (extra user units)
# and system/ (root-owned files, read by install_omarchy_system.sh). A new
# machine needs no dir there to get the shared setup.
set -eu

dotfiles="${DOTFILES:-$HOME/.dotfiles}"
scripts="$dotfiles/scripts"
host="${DOTFILES_HOST:-$(hostname)}"
bashrc_line='[ -f ~/.dotfiles/config/bash/omarchy.bash ] && source ~/.dotfiles/config/bash/omarchy.bash'

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
	echo "Usage: scripts/bootstrap_omarchy.sh [--help] [--dry-run] [--force] [--skip-root]"
	echo
	echo "Options:"
	echo "  --help, -h   Show this help message"
	echo "  --dry-run    Report what would change, touch nothing"
	echo "  --force      Let link_config.sh replace existing configs, backing them"
	echo "               up first; what a fresh omarchy install needs"
	echo "  --skip-root  Skip the package and system file steps, which need root"
	echo
	echo "Steps: link configs, hook config/bash/omarchy.bash into ~/.bashrc,"
	echo "install packages, install this host's system files, enable user units,"
	echo "make iCloud Mail the mailto handler, re-render the theme templates."
	exit 0
fi

dry_run=false
force=false
skip_root=false
for arg in "$@"; do
	case "$arg" in
	--dry-run) dry_run=true ;;
	--force) force=true ;;
	--skip-root) skip_root=true ;;
	*)
		echo "unknown option: $arg" >&2
		echo "try: scripts/bootstrap_omarchy.sh --help" >&2
		exit 1
		;;
	esac
done

# A non-interactive shell (ssh without a tty) does not get omarchy's env, and
# without OMARCHY_PATH the theme commands look for themes under /themes. Same
# fallback as config/hypr/hyprland.lua.
export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"

if ! command -v omarchy >/dev/null 2>&1; then
	echo "omarchy not found; this script is for omarchy hosts" >&2
	exit 1
fi

step() {
	echo
	echo "== $1"
}

# Strips comments and blank lines from a one-entry-per-line list file.
read_list() {
	[ -f "$1" ] || return 0
	sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]].*//' "$1" | grep -v '^$' || true
}

pass_through=""
[ "$dry_run" = true ] && pass_through="--dry-run"

step "link configs ($host)"
link_args="$pass_through"
[ "$force" = true ] && link_args="$link_args --force"
# Stops here on conflicts, before anything is built on half-linked configs.
# shellcheck disable=SC2086
"$scripts/link_config.sh" $link_args

step "bash loader in ~/.bashrc"
if grep -qF 'config/bash/omarchy.bash' "$HOME/.bashrc" 2>/dev/null; then
	echo "ok, already sourced"
elif [ "$dry_run" = true ]; then
	echo "would append: $bashrc_line"
else
	printf '\n%s\n' "$bashrc_line" >>"$HOME/.bashrc"
	echo "appended to ~/.bashrc"
fi

if [ "$skip_root" = true ]; then
	step "packages and system files"
	echo "skipped; run these from a terminal later:"
	echo "  scripts/install_omarchy_packages.sh"
	echo "  scripts/install_omarchy_system.sh"
else
	step "packages"
	# shellcheck disable=SC2086
	"$scripts/install_omarchy_packages.sh" $pass_through

	step "system files ($host)"
	# shellcheck disable=SC2086
	"$scripts/install_omarchy_system.sh" $pass_through
fi

step "user units"
units="$(read_list "$dotfiles/config/omarchy/units") $(read_list "$dotfiles/config/omarchy/hosts/$host/units")"
[ "$dry_run" = true ] || systemctl --user daemon-reload
for unit in $units; do
	if systemctl --user is-enabled --quiet "$unit" 2>/dev/null && systemctl --user is-active --quiet "$unit"; then
		echo "$unit: ok, enabled and running"
	elif [ "$dry_run" = true ]; then
		echo "$unit: would enable and start"
	else
		systemctl --user enable --now "$unit"
		echo "$unit: enabled and started"
	fi
done

step "mailto handler"
if [ "$(xdg-mime query default x-scheme-handler/mailto)" = "icloud-mail.desktop" ]; then
	echo "ok, already icloud-mail.desktop"
elif [ "$dry_run" = true ]; then
	echo "would set icloud-mail.desktop"
else
	xdg-mime default icloud-mail.desktop x-scheme-handler/mailto
	echo "set to icloud-mail.desktop"
fi

# The themed/*.tpl files only turn into real configs when the theme is
# rendered; without this the starship prompt config does not exist yet.
step "theme templates"
if [ "$dry_run" = true ]; then
	echo "would run: omarchy theme refresh"
else
	omarchy theme refresh
	echo "refreshed"
fi

echo
echo "done. open a new terminal to pick up the bash config."
