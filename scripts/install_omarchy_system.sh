#!/usr/bin/env bash
# Installs system-level files onto an omarchy host: everything below
# config/omarchy/system/ (every host) and config/omarchy/hosts/<hostname>/system/
# (this host) is copied to the same path under /. A path in both comes from
# the host's tree.
#
# The shared tree is what every machine wants (keyd's Mac Option letters); the
# host trees are fixes for one machine's hardware.
# DOTFILES_HOST overrides the hostname, for a dry run of another host.
#
# These are root-owned files outside ~/.config, so they cannot be symlinked
# the way link_config.sh does it. Idempotent: unchanged files are skipped.
# Needs root: from a terminal that is a sudo password prompt, without one it
# is a pkexec dialog.
set -eu

dotfiles="${DOTFILES:-$HOME/.dotfiles}"
host="${DOTFILES_HOST:-$(hostname)}"
shared_root="$dotfiles/config/omarchy/system"
src_root="$dotfiles/config/omarchy/hosts/$host/system"

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
	echo "Usage: scripts/install_omarchy_system.sh [--help] [--dry-run]"
	echo
	echo "Options:"
	echo "  --help, -h   Show this help message"
	echo "  --dry-run    Report what would be copied, touch nothing"
	echo
	echo "Copies $shared_root/<path> and"
	echo "$src_root/<path> to /<path> for every file, then reloads udev"
	echo "rules and re-triggers power_supply events so new rules take effect."
	echo "A changed NetworkManager drop-in reloads NetworkManager; a changed"
	echo "Limine drop-in rebuilds the boot image (takes effect after a reboot); a"
	echo "changed t2fand.conf restarts t2fanrd; a changed keyd config enables keyd"
	echo "and reloads it; a changed systemd unit reloads systemd; a changed journald"
	echo "drop-in restarts journald."
	exit 0
fi

dry_run=false
for arg in "$@"; do
	case "$arg" in
	--dry-run) dry_run=true ;;
	*)
		echo "unknown option: $arg" >&2
		echo "try: scripts/install_omarchy_system.sh --help" >&2
		exit 1
		;;
	esac
done

# Published path -> source file; the host tree is read last so it wins.
declare -A src_of
for root in "$shared_root" "$src_root"; do
	[ -d "$root" ] || continue
	while IFS= read -r src; do
		src_of["${src#"$root"}"]="$src"
	done < <(find "$root" -type f)
done

if [ "${#src_of[@]}" -eq 0 ]; then
	echo "no system files for $host, nothing to install"
	exit 0
fi

as_root() {
	if [ "$(id -u)" = 0 ]; then
		"$@"
	elif [ -t 0 ]; then
		sudo "$@"
	else
		pkexec "$@"
	fi
}

changed=""
while IFS= read -r rel; do
	src="${src_of[$rel]}"
	if [ -f "$rel" ] && cmp -s "$src" "$rel"; then
		echo "$rel"
		echo "    ok, up to date"
		continue
	fi
	echo "$rel"
	if [ -f "$rel" ]; then
		echo "    differs, will replace"
	else
		echo "    missing, will install"
	fi
	changed="$changed $rel"
done < <(printf '%s\n' "${!src_of[@]}" | sort)

if [ -z "$changed" ]; then
	echo
	echo "nothing to do"
	exit 0
fi

if [ "$dry_run" = true ]; then
	echo
	echo "dry run, nothing installed"
	exit 0
fi

# One root invocation for the whole batch, so a single password prompt.
script="set -e"
reload_nm=false
rebuild_boot=false
restart_fans=false
reload_keyd=false
reload_units=false
restart_journald=false
for rel in $changed; do
	src="${src_of[$rel]}"
	mode=$(stat -c '%a' "$src")
	script="$script; install -D -m $mode '$src' '$rel'"
	case "$rel" in
	/etc/NetworkManager/*) reload_nm=true ;;
	/etc/limine-entry-tool.d/*) rebuild_boot=true ;;
	/etc/t2fand.conf) restart_fans=true ;;
	/etc/keyd/*) reload_keyd=true ;;
	/etc/systemd/system/*) reload_units=true ;;
	/etc/systemd/journald.conf.d/*) restart_journald=true ;;
	esac
done
script="$script; udevadm control --reload; udevadm trigger --subsystem-match=power_supply --action=change"
[ "$reload_nm" = true ] && script="$script; nmcli general reload"
[ "$rebuild_boot" = true ] && script="$script; limine-mkinitcpio"
[ "$restart_fans" = true ] && script="$script; systemctl restart t2fanrd"
# A running keyd is told to reload; a stopped one reads the new file on start.
# `keyd reload` right after `enable --now` races the socket, hence the order.
[ "$reload_keyd" = true ] && script="$script; if systemctl is-active --quiet keyd; then keyd reload; fi; systemctl enable --now keyd"
# sleep.conf.d drop-ins need no reload: systemd-sleep reads them on each suspend.
[ "$reload_units" = true ] && script="$script; systemctl daemon-reload"
[ "$restart_journald" = true ] && script="$script; systemctl restart systemd-journald"
as_root sh -c "$script"

echo
echo "installed:$changed"
