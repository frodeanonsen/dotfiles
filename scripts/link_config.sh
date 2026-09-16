#!/usr/bin/env bash
# Symlinks the tool configs in config/ into ~/.config.
#
# This machine (omarchy) does not use nix, so the links that
# linux/*-configuration.nix declares via home.file are made here instead.
set -eu

dotfiles="${DOTFILES:-$HOME/.dotfiles}"
src_dir="$dotfiles/config"
dst_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
backup_dir="$dst_dir/.dotfiles-backup/$(date +%Y%m%d%H%M%S)"

# <name in ~/.config>:<dir under config/>
#
# Only real XDG config dirs belong here. The other config/* dirs are shell
# topic dirs (aliases.zsh, env.fish, ...) sourced straight from $DOTFILES by
# zsh/zshrc and fish/conf.d/config.fish, and macos-only tools (aerospace,
# sketchybar, skhd, yabai, iterm) have no target on linux.
#
# Deliberately absent: alacritty, ghostty, kitty. Not in use on this host,
# and the live omarchy versions of those are the ones that work here.
links="
atuin:atuin
fish:fish
lazygit:lazygit
nix:nix
nvim:lazyvim
ohmyposh:ohmyposh
starship:starship
tmux:tmux
toolkit:toolkit
wezterm:wezterm
zed:zed
zellij:zellij
"

dry_run=false
force=false

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
	echo "Usage: scripts/link_config.sh [--help] [--dry-run] [--force]"
	echo
	echo "Options:"
	echo "  --help, -h   Show this help message"
	echo "  --dry-run    Report what would change, touch nothing"
	echo "  --force      Replace existing files, backing them up first"
	echo
	echo "Without --force, anything already present in ~/.config that is not"
	echo "already the right symlink is left alone and reported as a conflict."
	echo "Backups go to \$XDG_CONFIG_HOME/.dotfiles-backup/<timestamp>/."
	exit 0
fi

for arg in "$@"; do
	case "$arg" in
	--dry-run) dry_run=true ;;
	--force) force=true ;;
	*)
		echo "unknown option: $arg" >&2
		echo "try: scripts/link_config.sh --help" >&2
		exit 1
		;;
	esac
done

linked=0
skipped=0
conflicts=0

# Moves an existing path aside into the timestamped backup dir.
back_up() {
	target="$1"
	if [ "$dry_run" = true ]; then
		echo "    would back up to $backup_dir/$(basename "$target")"
		return
	fi
	mkdir -p "$backup_dir"
	mv "$target" "$backup_dir/"
	echo "    backed up to $backup_dir/$(basename "$target")"
}

make_link() {
	src="$1"
	target="$2"
	if [ "$dry_run" = true ]; then
		echo "    would link $target -> $src"
		return
	fi
	ln -s "$src" "$target"
	echo "    linked $target -> $src"
}

[ "$dry_run" = true ] && echo "dry run, nothing will be changed"
echo "$src_dir -> $dst_dir"
echo

[ "$dry_run" = true ] || mkdir -p "$dst_dir"

for entry in $links; do
	name="${entry%%:*}"
	source_name="${entry##*:}"
	src="$src_dir/$source_name"
	target="$dst_dir/$name"

	echo "$name"

	if [ ! -d "$src" ]; then
		echo "    MISSING source $src, skipping"
		conflicts=$((conflicts + 1))
		continue
	fi

	# Already pointing where we want it.
	if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
		echo "    ok, already linked"
		skipped=$((skipped + 1))
		continue
	fi

	# Nothing in the way. A dangling symlink counts as in the way, hence -L.
	if [ ! -e "$target" ] && [ ! -L "$target" ]; then
		make_link "$src" "$target"
		linked=$((linked + 1))
		continue
	fi

	# Identical content is not worth a backup or a prompt.
	if [ ! -L "$target" ] && diff -r "$target" "$src" >/dev/null 2>&1; then
		echo "    identical content, converting to symlink"
		[ "$dry_run" = true ] || rm -rf "$target"
		make_link "$src" "$target"
		linked=$((linked + 1))
		continue
	fi

	if [ "$force" = false ]; then
		echo "    CONFLICT: $target exists and differs, left alone"
		echo "    diff -ru '$target' '$src'"
		echo "    re-run with --force to replace it"
		conflicts=$((conflicts + 1))
		continue
	fi

	back_up "$target"
	make_link "$src" "$target"
	linked=$((linked + 1))
done

echo
echo "$linked linked, $skipped already correct, $conflicts conflicts"

if [ "$conflicts" -gt 0 ] && [ "$force" = false ]; then
	echo "resolve the conflicts above, or re-run with --force"
	exit 1
fi
